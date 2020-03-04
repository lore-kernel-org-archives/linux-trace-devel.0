Return-Path: <SRS0=Pf13=4V=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA748C3F2CE
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Mar 2020 21:09:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81DC420842
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Mar 2020 21:09:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgCDVJ5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Mar 2020 16:09:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:47292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728614AbgCDVJ5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Mar 2020 16:09:57 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59C1620842;
        Wed,  4 Mar 2020 21:09:56 +0000 (UTC)
Date:   Wed, 4 Mar 2020 16:09:54 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v22 01/13] trace-cmd: Find and store pids of tasks,
 which run virtual CPUs of given VM
Message-ID: <20200304160954.06cea71e@gandalf.local.home>
In-Reply-To: <20200304091220.30936-2-tz.stoyanov@gmail.com>
References: <20200304091220.30936-1-tz.stoyanov@gmail.com>
        <20200304091220.30936-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed,  4 Mar 2020 11:12:08 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +static int read_qemu_guests_pids(char *guest_task, struct guest *guest)
> +{
> +	struct dirent *entry;
> +	char path[PATH_MAX];
> +	char *buf = NULL;
> +	size_t n = 0;
> +	int ret = 0;
> +	long vcpu;
> +	long pid;
> +	DIR *dir;
> +	FILE *f;
> +
> +	snprintf(path, sizeof(path), "/proc/%s/task", guest_task);
> +	dir = opendir(path);
> +	if (!dir)
> +		return -1;
> +
> +	while (!ret && (entry = readdir(dir))) {
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
> +					ret = 1;

Small nit. For errors, I usually return negative numbers (positive numbers
are usually successful values). But unless there another issue with this
series, this is not big enough for a resend. I could always just patch it
as well.

-- Steve

> +			}
> +		}
> +
> +		fclose(f);
> +	}
> +	free(buf);
> +	return ret;
> +}
