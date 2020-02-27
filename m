Return-Path: <SRS0=GfdA=4P=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE7F2C11D3D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Feb 2020 17:23:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A204F246A2
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Feb 2020 17:23:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729800AbgB0RXG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Feb 2020 12:23:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:44270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728413AbgB0RXF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Feb 2020 12:23:05 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC483246A0;
        Thu, 27 Feb 2020 17:23:04 +0000 (UTC)
Date:   Thu, 27 Feb 2020 12:23:03 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v20 03/15] trace-cmd: Find and store pids of tasks,
 which run virtual CPUs of given VM
Message-ID: <20200227122303.25dacb7b@gandalf.local.home>
In-Reply-To: <20200227142001.61577-4-tz.stoyanov@gmail.com>
References: <20200227142001.61577-1-tz.stoyanov@gmail.com>
        <20200227142001.61577-4-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 27 Feb 2020 16:19:49 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> 
> In order to match host and guest events, a mapping between guest VCPU
> and the host task, running this VCPU is needed. Extended existing
> struct guest to hold such mapping and added logic in read_qemu_guests()
> function to initialize it. Implemented a new internal API,
> get_guest_vcpu_pid(), to retrieve VCPU-task mapping for given VM.
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  tracecmd/include/trace-local.h |  2 +
>  tracecmd/trace-record.c        | 77 ++++++++++++++++++++++++++++++++++
>  2 files changed, 79 insertions(+)
> 
> diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
> index 29f27793..a5cf0640 100644
> --- a/tracecmd/include/trace-local.h
> +++ b/tracecmd/include/trace-local.h
> @@ -247,6 +247,8 @@ void update_first_instance(struct buffer_instance *instance, int topt);
>  
>  void show_instance_file(struct buffer_instance *instance, const char *name);
>  
> +int get_guest_vcpu_pid(unsigned int guest_cid, unsigned int guest_vcpu);
> +
>  /* moved from trace-cmd.h */
>  void tracecmd_create_top_instance(char *name);
>  void tracecmd_remove_instances(void);
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 28fe31b7..4370c964 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -3035,11 +3035,30 @@ struct guest {
>  	char *name;
>  	int cid;
>  	int pid;
> +	int cpu_max;
> +	int *cpu_pid;
>  };
>  
>  static struct guest *guests;
>  static size_t guests_len;
>  
> +static int set_vcpu_pid_mapping(struct guest *guest, int cpu, int pid)
> +{
> +	int *cpu_pid;
> +
> +	if (cpu < 0 || pid < 0)
> +		return -1;

This check makes the check before its call not needed (see below).

> +	if (cpu >= guest->cpu_max) {
> +		cpu_pid = realloc(guest->cpu_pid, (cpu + 1) * sizeof(int));

It is possible that the cpu numbers may be sparse, which means we should we
should probably initialize the new numbers as...

> +		if (!cpu_pid)
> +			return -1;

		/* Handle sparse CPU numbers */
		for (i = guest->cpu_max; i < cpu; i++)
			guest->cpu_pid[i] = -1;

Note, the above wont loop at all if there's no sparse CPUs (missing
numbers).

> +		guest->cpu_max = cpu + 1;
> +		guest->cpu_pid = cpu_pid;
> +	}
> +	guest->cpu_pid[cpu] = pid;
> +	return 0;
> +}
> +
>  static char *get_qemu_guest_name(char *arg)
>  {
>  	char *tok, *end = arg;
> @@ -3052,6 +3071,46 @@ static char *get_qemu_guest_name(char *arg)
>  	return arg;
>  }
>  
> +static void read_qemu_guests_pids(char *guest_task, struct guest *guest)

Probably should return a status.

> +{
> +	struct dirent *entry;
> +	char path[PATH_MAX];
> +	char *buf = NULL;
> +	size_t n = 0;
> +	long int vcpu;
> +	long int pid;

"int" is not needed. Just "long" is good enough.

	long vcpu;
	long pid;

Although, I doubt there will be more than 4 billion of either of these, so
they should probably be just "int". Which means you don't need the INT_MAX
checks.

> +	DIR *dir;
> +	FILE *f;
> +
> +	snprintf(path, sizeof(path), "/proc/%s/task", guest_task);
> +	dir = opendir(path);
> +	if (!dir)
> +		return;
> +
> +	while ((entry = readdir(dir))) {
> +		if (!(entry->d_type == DT_DIR && is_digits(entry->d_name)))
> +			continue;
> +
> +		snprintf(path, sizeof(path), "/proc/%s/task/%s/comm",
> +			 guest_task, entry->d_name);
> +		f = fopen(path, "r");
> +		if (!f)
> +			continue;
> +
> +		if (getline(&buf, &n, f) >= 0 &&
> +		    strncmp(buf, "CPU ", 4) == 0) {
> +			vcpu = strtol(buf + 4, NULL, 10);
> +			pid = strtol(entry->d_name, NULL, 10);
> +			if (vcpu < INT_MAX && pid < INT_MAX &&
> +			    vcpu >= 0 && pid >= 0)

The vcpu >= 0 && pid >= 0 are not needed due to the check in the function.

> +				set_vcpu_pid_mapping(guest, vcpu, pid);

Probably should check the return status of this function, and report a
warning if it fails.

> +		}
> +
> +		fclose(f);
> +	}
> +	free(buf);
> +}
> +
>  static void read_qemu_guests(void)
>  {
>  	static bool initialized;
> @@ -3115,6 +3174,8 @@ static void read_qemu_guests(void)
>  		if (!is_qemu)
>  			goto next;
>  
> +		read_qemu_guests_pids(entry->d_name, &guest);

Should probably check the status of the above function. Die on error?

> +
>  		guests = realloc(guests, (guests_len + 1) * sizeof(*guests));
>  		if (!guests)
>  			die("Can not allocate guest buffer");
> @@ -3160,6 +3221,22 @@ static char *parse_guest_name(char *guest, int *cid, int *port)
>  	return guest;
>  }
>  
> +int get_guest_vcpu_pid(unsigned int guest_cid, unsigned int guest_vcpu)
> +{
> +	int i;
> +
> +	if (!guests)
> +		return -1;
> +
> +	for (i = 0; i < guests_len; i++) {
> +		if (!guests[i].cpu_pid || guest_vcpu >= guests[i].cpu_max)

As a cpu_pid may be zero (unlikely), and the code I showed above
initialized sparse cpus as -1, then this should be guests[i].cpu_pid < 0.

-- Steve

> +			continue;
> +		if (guest_cid == guests[i].cid)
> +			return guests[i].cpu_pid[guest_vcpu];
> +	}
> +	return -1;
> +}
> +
>  static void set_prio(int prio)
>  {
>  	struct sched_param sp;

