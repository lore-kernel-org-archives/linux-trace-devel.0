Return-Path: <SRS0=nG5h=4T=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.6 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A4EAC3F2D1
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Mar 2020 16:25:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E009921D56
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Mar 2020 16:25:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgCBQZ5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 2 Mar 2020 11:25:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:43018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726946AbgCBQZ5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 2 Mar 2020 11:25:57 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE2DF21556;
        Mon,  2 Mar 2020 16:25:56 +0000 (UTC)
Date:   Mon, 2 Mar 2020 11:25:55 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v21 01/13] trace-cmd: Find and store pids of tasks,
 which run virtual CPUs of given VM
Message-ID: <20200302112555.037566e1@gandalf.local.home>
In-Reply-To: <20200302101404.150035-2-tz.stoyanov@gmail.com>
References: <20200302101404.150035-1-tz.stoyanov@gmail.com>
        <20200302101404.150035-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon,  2 Mar 2020 12:13:52 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +static int read_qemu_guests_pids(char *guest_task, struct guest *guest)
> +{
> +	struct dirent *entry;
> +	char path[PATH_MAX];
> +	char *buf = NULL;
> +	size_t n = 0;
> +	long vcpu;
> +	long pid;
> +	DIR *dir;
> +	FILE *f;

	int ret = 0;

> +
> +	snprintf(path, sizeof(path), "/proc/%s/task", guest_task);
> +	dir = opendir(path);
> +	if (!dir)
> +		return -1;
> +
> +	while ((entry = readdir(dir))) {

	while (!ret && (entry = readdir(dir)) {

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
> +			    vcpu >= 0 && pid >= 0) {
> +				if (set_vcpu_pid_mapping(guest, vcpu, pid))
> +					return -1;
> +			}

Perhaps this should error on else. Also, you don't want a return here, but
instead, a break.

				if (...) {
					ret = -1;
					break;
				}

> +		}
> +
> +		fclose(f);
> +	}
> +	free(buf);
> +	return 0;

	return ret;

Otherwise you don't close the file descriptor and free buf.

-- Steve


> +}
> +
>  static void read_qemu_guests(void)
>  {
>  	static bool initialized;
> @@ -3115,6 +3179,10 @@ static void read_qemu_guests(void)
>  		if (!is_qemu)
>  			goto next;
>  
> +		if (read_qemu_guests_pids(entry->d_name, &guest))
> +			warning("Failed to retrieve VPCU - PID mapping for guest %s",
> +					guest.name ? guest.name : "Unknown");
> +
>  		guests = realloc(guests, (guests_len + 1) * sizeof(*guests));
>  		if (!guests)
>  			die("Can not allocate guest buffer");
> @@ -3160,6 +3228,22 @@ static char *parse_guest_name(char *guest, int *cid, int *port)
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
> +		if (guests[i].cpu_pid < 0 || guest_vcpu >= guests[i].cpu_max)
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

