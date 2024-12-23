package com.example.AppDemo;

import java.util.Random;

import org.springframework.web.bind.annotation.*;
import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.Gauge;
import io.micrometer.core.instrument.MeterRegistry;

@RestController
@RequestMapping("/api/fibonacci")
public class FibonacciController {

    private Counter counter;
    private Gauge gauge;

    public FibonacciController(MeterRegistry meterRegistry) {
        // counter
        this.counter = Counter.builder("appdemo_http_requests_total").
            tag("version", "v1.0").
            tag("server", "dev").
            tag("city", "Ho Chi Minh City").
            tag("region", "Southeast").
            description("App Demo HTTP Requests Total").
            register(meterRegistry);

        // gauge
         Gauge.builder("temperature", () -> {
                double min = 10, max = 30;
                return min + new Random().nextDouble() * (max - min);
            }).
            tag("version", "v1.0").
            tag("server", "dev").
            tag("city", "Ho Chi Minh City").
            tag("region", "Southeast").
            description("Temperature Today!").
            register(meterRegistry);
    }

    // Iterative Fibonacci
    @GetMapping("/{n}")
    public long fibonacciIterative(@PathVariable int n) {
        if (n < 0) {
            throw new IllegalArgumentException("Input must be a non-negative integer.");
        }
        if (n == 0) return 0;
        if (n == 1) return 1;

        long a = 0, b = 1, result = 0;
        for (int i = 2; i <= n; i++) {
            result = a + b;
            a = b;
            b = result;
        }
        counter.increment();
        return result;
    }
}