from metaflow import (
    FlowSpec,
    step,
    kubernetes,
    retry,
    environment,
    Config
)


class FinetuneFlow(FlowSpec):
    flow_config = Config("config", default="flow_config.json")

    @step
    def start(self):
        """
        The 'start' step is a regular step, so runs locally on the machine from
        which the flow is executed.

        """
        from metaflow import get_metadata

        print("FinetuneFlow is starting.")
        print("")
        print("Using metadata provider: %s" % get_metadata())
        print("")
        print("The start step is running locally. Next, the ")
        print("'finetune' step will run remotely on Kubernetes. ")

        self.next(self.finetune)

    @environment(vars={
        "MODEL_NAME": "google/gemma-2-9b",
        "NEW_MODEL": "gemma-2-9b-sql-finetuned-arkamalov-test",
        "LORA_R": "8",
        "LORA_ALPHA": "16",
        "TRAIN_BATCH_SIZE": "1",
        "EVAL_BATCH_SIZE": "2",
        "GRADIENT_ACCUMULATION_STEPS": "2",
        "DATASET_LIMIT": "1000",
        "MAX_SEQ_LENGTH": "512",
        "LOGGING_STEPS": "5",
    })
    @kubernetes(
        image=flow_config.image,
        cpu=0.5,
        memory=500,
        gpu=1,
        secrets=["hf-token"],
    )
    @retry
    @step
    def finetune(self):
        self.message = "Hi from the cloud!"
        print("Metaflow says: %s" % self.message)
        import finetune
        self.next(self.end)

    @step
    def end(self):
        """
        The 'end' step is a regular step, so runs locally on the machine from
        which the flow is executed.

        """
        print("FinetuneFlow is finished.")


if __name__ == "__main__":
    FinetuneFlow()
