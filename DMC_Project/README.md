# NSWI130 Software System Architectures

## Spouštění Structurizru

**Před prvním spuštěním:**

```sh
docker pull structurizr/lite
cd <folder, kde budeme pracovat>
docker create --name structurizr-ssa -p 8080:8080 -v $PWD:/usr/local/structurizr structurizr/lite
```

Nyní máme nespuštěný kontejner, vidět je v `docker container ls -a`.

**Spustit/zastavit kontejner:**

```sh
docker start structurizr-ssa
docker stop structurizr-ssa
```

- kontejner se tak nemusí znovu konfigurovat, nemusí se znovu přijímat podmínky
- kontejner běží na pozadí, mimo shell

**Smazání zastavených kontejnerů:**

```sh
docker container prune
```
