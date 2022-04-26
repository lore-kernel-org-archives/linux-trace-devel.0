Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B12DBC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Apr 2022 01:46:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241360AbiDZBtM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 25 Apr 2022 21:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241338AbiDZBtK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 25 Apr 2022 21:49:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 269BC33367;
        Mon, 25 Apr 2022 18:46:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B603861736;
        Tue, 26 Apr 2022 01:46:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A7E0C385A4;
        Tue, 26 Apr 2022 01:46:01 +0000 (UTC)
Date:   Mon, 25 Apr 2022 21:45:59 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Kacur <jkacur@redhat.com>, Daniel Wagner <dwagner@suse.de>
Subject: Re: [PATCH 1/2] rtla: Remove procps-ng dependency
Message-ID: <20220425214559.55988956@gandalf.local.home>
In-Reply-To: <52161d343abeda6d039d2f0734904a1383a4c62e.1650617571.git.bristot@kernel.org>
References: <52161d343abeda6d039d2f0734904a1383a4c62e.1650617571.git.bristot@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 22 Apr 2022 12:01:31 +0200
Daniel Bristot de Oliveira <bristot@kernel.org> wrote:


> +
> +/*
> + * procfs_is_workload_pid - check if a procfs entry contains a workload_prefix* comm
> + *
> + * Check if the procfs entry is a directory of a process, and then check if the
> + * process has a comm with the prefix set in char *workload_prefix. As the
> + * current users of this function only check for kernel threads, there is no
> + * need to check for the threads for the process.
> + *
> + * Return: True if the proc_entry contains a comm file with workload_prefix*.
> + * Otherwise returns false.
> + */
> +static int procfs_is_workload_pid(const char *workload_prefix, struct dirent *proc_entry)
> +{
> +	char comm_path[MAX_PATH], comm[MAX_PATH];

This is probably fine (but there is one issue), but I would have done this
a little different.

	int len = strlen(workload_prefix);
	char comm[len + 1];

> +	int comm_fd, retval;
> +	char *t_name;
> +
> +	if (proc_entry->d_type != DT_DIR)
> +		return 0;
> +
> +	if (*proc_entry->d_name == '.')
> +		return 0;
> +
> +	/* check if the string is a pid */
> +	for (t_name = proc_entry->d_name; t_name; t_name++) {
> +		if (!isdigit(*t_name))
> +			break;
> +	}
> +
> +	if (*t_name != '\0')
> +		return 0;
> +
> +	snprintf(comm_path, MAX_PATH, "/proc/%s/comm", proc_entry->d_name);
> +	comm_fd = open(comm_path, O_RDONLY);
> +	if (comm_fd < 0)
> +		return 0;
> +
> +	memset(comm, 0, MAX_PATH);

No need for the memset.

> +	retval = read(comm_fd, comm, MAX_PATH);

	retval = read(comm_fd, comm, len + 1);

> +
> +	close(comm_fd);
> +
> +	if (retval <= 0)
> +		return 0;

	if (comm[len] != '\n')
		return 0;

> +
> +	retval = !strncmp(workload_prefix, comm, strlen(workload_prefix));

What happens if strlen(workload_prefix) is greater than MAX_PATH? ;-)

	retval = !strncmp(workload_prefix, comm, len);

But that's me. If you want to keep this as is, let me know.

-- Steve



> +	if (!retval)
> +		return 0;
> +
> +	/* comm already have \n */
> +	debug_msg("Found workload pid:%s comm:%s", proc_entry->d_name, comm);
> +
> +	return 1;
> +}
> +
