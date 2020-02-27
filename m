Return-Path: <SRS0=GfdA=4P=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E996CC4BA06
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Feb 2020 04:13:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF2FC24688
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Feb 2020 04:13:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727735AbgB0ENR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Feb 2020 23:13:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:35242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728221AbgB0ENR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Feb 2020 23:13:17 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 512572467A;
        Thu, 27 Feb 2020 04:13:16 +0000 (UTC)
Date:   Wed, 26 Feb 2020 23:13:14 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v19 03/15] trace-cmd: Find and store pids of tasks,
 which run virtual CPUs of given VM
Message-ID: <20200226231314.5d4a6e5f@oasis.local.home>
In-Reply-To: <20200131121111.130355-4-tz.stoyanov@gmail.com>
References: <20200131121111.130355-1-tz.stoyanov@gmail.com>
        <20200131121111.130355-4-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 31 Jan 2020 14:10:59 +0200
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
>  tracecmd/include/trace-local.h |  2 ++
>  tracecmd/trace-record.c        | 54 ++++++++++++++++++++++++++++++++++
>  2 files changed, 56 insertions(+)
> 
> diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
> index 29f2779..a5cf064 100644
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
> index 28fe31b..b479e91 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -3031,10 +3031,12 @@ static bool is_digits(const char *s)
>  	return true;
>  }
>  
> +#define VCPUS_MAX 256
>  struct guest {
>  	char *name;
>  	int cid;
>  	int pid;
> +	int cpu_pid[VCPUS_MAX];

Although this is probably fine for the near future, I don't like
arbitrary limits that don't have to do with max sizes of the storage
unit (like max int).

Why is the cpu_pid a static array and not one that is allocated? We
could use realloc, couldn't we, in the loading of it?

-- Steve

>  };
>  
>  static struct guest *guests;
> @@ -3052,6 +3054,43 @@ static char *get_qemu_guest_name(char *arg)
>  	return arg;
>  }
>  
> +static void read_qemu_guests_pids(char *guest_task, struct guest *guest)
> +{
> +	struct dirent *entry;
> +	char path[PATH_MAX];
> +	char *buf = NULL;
> +	size_t n = 0;
> +	int vcpu;
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
> +			vcpu = atoi(buf + 4);
> +			if (vcpu >= 0 && vcpu < VCPUS_MAX)
> +				guest->cpu_pid[vcpu] = atoi(entry->d_name);
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
> @@ -3115,6 +3154,8 @@ static void read_qemu_guests(void)
>  		if (!is_qemu)
>  			goto next;
>  
> +		read_qemu_guests_pids(entry->d_name, &guest);
> +
>  		guests = realloc(guests, (guests_len + 1) * sizeof(*guests));
>  		if (!guests)
>  			die("Can not allocate guest buffer");
> @@ -3160,6 +3201,19 @@ static char *parse_guest_name(char *guest, int *cid, int *port)
>  	return guest;
>  }
>  
> +int get_guest_vcpu_pid(unsigned int guest_cid, unsigned int guest_vcpu)
> +{
> +	int i;
> +
> +	if (!guests || guest_vcpu >= VCPUS_MAX)
> +		return -1;
> +
> +	for (i = 0; i < guests_len; i++)
> +		if (guest_cid == guests[i].cid)
> +			return guests[i].cpu_pid[guest_vcpu];
> +	return -1;
> +}
> +
>  static void set_prio(int prio)
>  {
>  	struct sched_param sp;

