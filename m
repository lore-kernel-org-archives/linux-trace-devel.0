Return-Path: <SRS0=nG5h=4T=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C82BC3F2CD
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Mar 2020 16:33:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D86021775
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Mar 2020 16:33:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgCBQdl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 2 Mar 2020 11:33:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:45868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726775AbgCBQdl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 2 Mar 2020 11:33:41 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7384421775;
        Mon,  2 Mar 2020 16:33:40 +0000 (UTC)
Date:   Mon, 2 Mar 2020 11:33:39 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v21 01/13] trace-cmd: Find and store pids of tasks,
 which run virtual CPUs of given VM
Message-ID: <20200302113339.0e61b83c@gandalf.local.home>
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

> +static int set_vcpu_pid_mapping(struct guest *guest, int cpu, int pid)
> +{
> +	int *cpu_pid;
> +	int i;
> +
> +	if (cpu >= guest->cpu_max) {
> +		cpu_pid = realloc(guest->cpu_pid, (cpu + 1) * sizeof(int));
> +		if (!cpu_pid)
> +			return -1;
> +		/* Handle sparse CPU numbers */
> +		for (i = guest->cpu_max; i < cpu; i++)
> +			guest->cpu_pid[i] = -1;

That needs to be: cpu_pid[i] = -1; as realloc() may have freed
guest->cpu_pid here.

-- Steve

> +		guest->cpu_max = cpu + 1;
> +		guest->cpu_pid = cpu_pid;
> +	}
> +	guest->cpu_pid[cpu] = pid;
> +	return 0;
> +}
