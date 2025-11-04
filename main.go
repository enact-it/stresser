package main

import (
	"flag"
	"io"
	"log"
	"os"
	"time"

	"k8s.io/apimachinery/pkg/api/resource"
)

var (
	argMemTotal         = flag.String("mem-total", "1Mi", "total memory to be consumed. Memory will be consumed via multiple allocations.")
	argMemStepSize      = flag.String("mem-alloc-size", "4Ki", "amount of memory to be consumed in each allocation")
	argMemSleepDuration = flag.Duration("mem-alloc-sleep", 100*time.Millisecond, "duration to sleep between allocations")
	argCpus             = flag.Int("cpus", 1, "total number of CPUs to utilize")
	buffer              [][]byte
)

func main() {
	flag.Parse()
	memTotal := resource.MustParse(*argMemTotal)
	memStepSize := resource.MustParse(*argMemStepSize)
	log.Printf("Allocating %q memory in %q chunks with a %v sleep", memTotal.String(), memStepSize.String(), *argMemSleepDuration)

	burnCPU(*argCpus)

	allocateMemory(memTotal, memStepSize)

	log.Printf("Allocated %q memory", memTotal.String())
	select {} // Make the program run indefinitely
}

// burnCPU spawns multiple goroutines to consume CPU resources.
//
// Each goroutine reads from /dev/zero and writes to io.Discard (equivalent to /dev/null).
// The number of goroutines spawned is determined by the value of the argCpus flag.
func burnCPU(cpus int) {
	src, err := os.Open("/dev/zero")
	if err != nil {
		log.Fatalf("failed to open /dev/zero")
	}
	for i := range cpus {
		log.Printf("Spawning thread %d to consume CPU", i)
		go func() {
			_, err := io.Copy(io.Discard, src)
			if err != nil {
				log.Fatalf("failed to copy from /dev/zero to /dev/null: %v", err)
			}
		}()
	}
}

func allocateMemory(total, stepSize resource.Quantity) {
	for i := int64(1); i*stepSize.Value() <= total.Value(); i++ {
		newBuffer := make([]byte, stepSize.Value())
		for i := range newBuffer {
			newBuffer[i] = 0
		}
		buffer = append(buffer, newBuffer)
		time.Sleep(*argMemSleepDuration)
	}
}
