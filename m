Return-Path: <SRS0=rw6q=Q5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73AC5C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 17:07:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42D6C20700
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 17:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbfBVRHQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Feb 2019 12:07:16 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33415 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbfBVRHP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Feb 2019 12:07:15 -0500
Received: by mail-wr1-f65.google.com with SMTP id i12so3184690wrw.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 22 Feb 2019 09:07:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fENB/879Q+uKv1SWm6Y9pWorre5hLSmzE50Qw+HS23g=;
        b=IJNLIOmRrU7hVYx/V+zavjYAWLirD3loQjrSsnlFCbtX1dID89xosTxRiHGYOCyrjv
         qJjnTmH1GTaCC6xqsBKRA6oKqK8fTWgPGF/jQC0CUzKl8n70at0THOOl5QPMdqLM8w/L
         rbuz/tOR1JdAPDk7R0N2XasNfdZVy+1Ext/NagRTqI4I0UrTWCiVmfZUlNDmdXb6knG4
         HOURgSsitSwbVWs2ByEl3Pm4uAV0uqRDR8r+iQgvgH0J82TBbmO5pMH8zutwz2thjmy5
         AXa95w+RgxN632144MQVhLdVefyUMxcWJh4Nk1Deg5xIwlTIElhO1GCGm0FhLRBjZEux
         GprQ==
X-Gm-Message-State: AHQUAubwwCLoezTfQ9V2RL7/LVsnqCV0BrzH2vXupNkwiyfuSRsOJt1+
        LlRxKFRmRk+jo0eo85ZTvw==
X-Google-Smtp-Source: AHgI3IaFr5KRirFWzChfZ4q0NSq241IyikT9Os7oWYjXyRgmY+kZGYgBY/wjfDjMRhmznHjpLf7NVA==
X-Received: by 2002:adf:c5d3:: with SMTP id v19mr3691589wrg.30.1550855232872;
        Fri, 22 Feb 2019 09:07:12 -0800 (PST)
Received: from box ([146.247.46.6])
        by smtp.gmail.com with ESMTPSA id d15sm5088216wrw.36.2019.02.22.09.07.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 22 Feb 2019 09:07:11 -0800 (PST)
Date:   Fri, 22 Feb 2019 19:07:09 +0200
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 6/7] trace-cmd: Find and store pids of tasks, which
 run virtual CPUs of given VM
Message-ID: <20190222170708.GB17098@box>
References: <20190222142836.12596-1-tstoyanov@vmware.com>
 <20190222142836.12596-7-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190222142836.12596-7-tstoyanov@vmware.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Feb 22, 2019 at 04:28:35PM +0200, Tzvetomir Stoyanov wrote:
> In order to match host and guest events, a mapping between guest VCPU
> and the host task, running this VCPU is needed. Extended existing
> struct guest to hold such mapping and added logic in read_qemu_guests()
> function to initialize it. Implemented a new internal API,
> get_guest_vcpu_pids(), to retrieve VCPU-task mapping for given VM.
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  tracecmd/include/trace-local.h |  3 ++
>  tracecmd/trace-record.c        | 57 +++++++++++++++++++++++++++++++++-
>  2 files changed, 59 insertions(+), 1 deletion(-)
> 
> diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
> index d7bdb1f..ef6848f 100644
> --- a/tracecmd/include/trace-local.h
> +++ b/tracecmd/include/trace-local.h
> @@ -236,6 +236,9 @@ void show_instance_file(struct buffer_instance *instance, const char *name);
>  
>  int count_cpus(void);
>  
> +#define VCPUS_MAX	256

Is VCPUS_MAX intended to be used somewhere outside of trace-record.c? If not, I
think we should keep it there locally and not expose it.

> +int *get_guest_vcpu_pids(int cid);
> +
>  /* No longer in event-utils.h */
>  void __noreturn die(const char *fmt, ...); /* Can be overriden */
>  void *malloc_or_die(unsigned int size); /* Can be overridden */
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index c57ed6b..59f0197 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -2752,6 +2752,7 @@ struct guest {
>  	char *name;
>  	int cid;
>  	int pid;
> +	int cpu_pid[VCPUS_MAX];
>  };
>  
>  static struct guest *guests;
> @@ -2772,9 +2773,10 @@ static char *get_qemu_guest_name(char *arg)
>  static void read_qemu_guests(void)
>  {
>  	static bool initialized;
> +	struct dirent *entry_t;
>  	struct dirent *entry;
>  	char path[PATH_MAX];
> -	DIR *dir;
> +	DIR *dir, *dir_t;
>  
>  	if (initialized)
>  		return;
> @@ -2830,6 +2832,49 @@ static void read_qemu_guests(void)
>  		if (!is_qemu)
>  			goto next;
>  

I think the following section should go into separate function since this one is
already getting too long. Then here we can just do:

		read_qemu_guest_vcpus(&guest);

Where read_qemu_guest_vcpus can be something like that:

static void read_qemu_guest_vcpus(struct guest *guest)
{
	struct dirent *entry;
	char path[PATH_MAX];
	size_t buf_len = 0;
	char *buf = NULL;
	int vcpu;
	DIR *dir;
	FILE *f;

	snprintf(path, sizeof(path), "/proc/%d/task", guest->pid);
	dir = opendir(path);
	if (!dir)
		return;

	for (entry = readdir(dir); entry; entry = readdir(dir)) {
		if (!(entry->d_type == DT_DIR && is_digits(entry->d_name)))
			continue;

		snprintf(path, sizeof(path), "/proc/%d/task/%s/comm",
			 guest->pid, entry->d_name);
		f = fopen(path, "r");
		if (!f)
			continue;

		if (getline(&buf, &buf_len, f) < 0)
			goto next;

		if (strncmp(buf, "CPU ", 4) != 0)
			goto next;

		vcpu = atoi(buf + 4);
		if (!(vcpu >= 0 && vcpu < VCPUS_MAX))
			goto next;

		guest->cpu_pid[vcpu] = atoi(entry->d_name);

next:
		fclose(f);
	}

	free(buf);
}

Thank you,

-- Slavi

> +		snprintf(path, sizeof(path), "/proc/%s/task", entry->d_name);
> +		dir_t = opendir(path);
> +		if (dir_t) {
> +			unsigned int vcpu;
> +			char *buf = NULL;
> +			char *cpu_str;
> +			FILE *ft;
> +			size_t n;
> +			int j;
> +
> +			for (entry_t = readdir(dir_t); entry_t; entry_t = readdir(dir_t)) {
> +				if (!(entry_t->d_type == DT_DIR &&
> +				    is_digits(entry_t->d_name)))
> +					continue;
> +				snprintf(path, sizeof(path),
> +					 "/proc/%s/task/%s/comm",
> +					 entry->d_name, entry_t->d_name);
> +				ft = fopen(path, "r");
> +				if (!ft)
> +					continue;
> +				getline(&buf, &n, ft);
> +				if (buf && strncmp(buf, "CPU ", 4) == 0) {
> +					cpu_str = buf;
> +					while (*cpu_str != '\0' &&
> +						isdigit(*cpu_str) == 0)
> +						cpu_str++;
> +					if (*cpu_str != '\0') {
> +						j = 0;
> +						while (cpu_str[j] != '\0' &&
> +						       isdigit(cpu_str[j]) != 0)
> +							j++;
> +						cpu_str[j] = '\0';
> +						vcpu = atoi(cpu_str);
> +						if (vcpu < VCPUS_MAX)
> +							guest.cpu_pid[vcpu] = atoi(entry_t->d_name);
> +					}
> +				}
> +				free(buf);
> +				fclose(ft);
> +				buf = NULL;
> +			}
> +		}
> +
>  		guests = realloc(guests, (guests_len + 1) * sizeof(*guests));
>  		if (!guests)
>  			die("Can not allocate guest buffer");
> @@ -2875,6 +2920,16 @@ static char *parse_guest_name(char *guest, int *cid, int *port)
>  	return guest;
>  }
>  
> +int *get_guest_vcpu_pids(int cid)
> +{
> +	int i;
> +
> +	for (i = 0; i < guests_len; i++)
> +		if (cid == guests[i].cid)
> +			return guests[i].cpu_pid;
> +	return NULL;
> +}
> +
>  static void set_prio(int prio)
>  {
>  	struct sched_param sp;
> -- 
> 2.20.1
> 
