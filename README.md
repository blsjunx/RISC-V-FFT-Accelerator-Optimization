# RISC-V FFT Accelerator Optimization

RISC-V 기반 FFT 가속기에서
메모리 접근 및 연산 흐름을 최적화한 프로젝트
(Konkuk University, 2025)

---

##  개요

본 프로젝트는 Radix-2 FFT를 대상으로
**메모리 접근, 연산 스케줄링, 병렬 실행 구조를 최적화**하는 것을 목표로 한다.

* 64-point FFT 구현 
* Butterfly 기반 연산 구조

---

## 구조

### 🔹 FFT 데이터 흐름

* Radix-2 Butterfly 연산
* 각 stage에서:

  * load → compute → store 구조

--> FFT는 반복적인 memory access + MAC 연산 구조

---

### 🔹 시스템 구성

* SRAM_I/O (input/output)
* SRAM_0 (intermediate buffer)
* SRAM_W (twiddle factor)
* Dpath_reg (연산 유닛)

--> scratchpad 기반 메모리 구조

---

## 핵심 최적화

### 1. Memory access 최적화

* Stage 0에서 SRAM bypass

  * SRAM_I/O → Dpath_reg 직접 연결
    → latency 감소 

---

### 2. 주소 계산 제거

* 주소 offset을 lookup table로 미리 계산
* loop / branch 제거

--> instruction overhead 감소 

---

### 3. Twiddle factor reuse

* 같은 twiddle factor를 묶어서 처리
* memory access 최소화

---

### 4. Pipeline overlap

* 다음 butterfly input을 미리 preload
* 연산과 memory access 겹침

--> idle cycle 제거

---

### 5. Multi-core 병렬화 (TP2)

* 3개 core를 활용하여 작업 분할 
* stage 간 병렬 execution

---

### 6. Cycle alignment

* butterfly 연산을 3의 배수 cycle로 정렬
  → SRAM 1R1W 충돌 방지 

---

## 특징

* Bit-reversed addressing 적용
* Preload 기반 latency hiding
* Fully hand-optimized RISC-V assembly

---

## 참고

자세한 flow 및 최적화 과정:
* TP_2_final.pdf
