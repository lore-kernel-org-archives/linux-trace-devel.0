Return-Path: <SRS0=K4HJ=PW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C14FDC43387
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jan 2019 22:10:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A3FE20656
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jan 2019 22:10:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfANWKt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jan 2019 17:10:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:37968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726618AbfANWKt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jan 2019 17:10:49 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F422205F4;
        Mon, 14 Jan 2019 22:10:48 +0000 (UTC)
Date:   Mon, 14 Jan 2019 17:10:46 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, ykaradzhov@vmware.com,
        tstoyanov@vmware.com
Subject: Re: [PATCH v3 3/6] trace-cmd: Add tracecmd_create_recorder_virt
 function
Message-ID: <20190114171046.6d46da9a@gandalf.local.home>
In-Reply-To: <20190114152800.31060-4-kaslevs@vmware.com>
References: <20190114152800.31060-1-kaslevs@vmware.com>
        <20190114152800.31060-4-kaslevs@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 14 Jan 2019 17:27:57 +0200
Slavomir Kaslev <kaslevs@vmware.com> wrote:


> @@ -194,8 +196,9 @@ tracecmd_create_buffer_recorder_fd(int fd, int cpu, unsigned flags, const char *
>  	return tracecmd_create_buffer_recorder_fd2(fd, -1, cpu, flags, buffer, 0);
>  }
>  
> -struct tracecmd_recorder *
> -tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags, const char *buffer)
> +static struct tracecmd_recorder *
> +__tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags,
> +				  const char *buffer)
>  {
>  	struct tracecmd_recorder *recorder;
>  	int fd;
> @@ -258,6 +261,26 @@ tracecmd_create_buffer_recorder_maxkb(const char *file, int cpu, unsigned flags,
>  	goto out;
>  }
>  
> +struct tracecmd_recorder *
> +tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags,
> +				const char *buffer)
> +{
> +	return __tracecmd_create_buffer_recorder(file, cpu, flags, buffer);
> +}
> +
> +struct tracecmd_recorder *
> +tracecmd_create_recorder_virt(const char *file, int cpu, int trace_fd)

As this looks to be something that may be a library call someday, I
would keep flags as a parameter.

> +{
> +	struct tracecmd_recorder *recorder;
> +
> +	recorder = __tracecmd_create_buffer_recorder(
> +		file, cpu, TRACECMD_RECORD_NOSPLICE, NULL);

Then you could pass this as:

	recorder = __tracecmd_create_buffer_recorder(file, cpu,
			flags | TRACECMD_RECORD_NOSPLICE, NULL);

-- Steve

> +	if (recorder)
> +		recorder->trace_fd = trace_fd;
> +
> +	return recorder;
> +}
> +
>  struct tracecmd_recorder *tracecmd_create_recorder_fd(int fd, int cpu, unsigned flags)
>  {
>  	const char *tracing;

