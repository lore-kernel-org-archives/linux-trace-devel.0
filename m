Return-Path: <SRS0=blm6=QP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7D5EC169C4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Feb 2019 22:44:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C18A21908
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Feb 2019 22:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbfBHWoM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Feb 2019 17:44:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:33526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbfBHWoM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Feb 2019 17:44:12 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E24C218DA;
        Fri,  8 Feb 2019 22:44:11 +0000 (UTC)
Date:   Fri, 8 Feb 2019 17:44:09 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 5/7] trace-cmd: Refactored make_instances() and
 tracecmd_remove_instances()
Message-ID: <20190208174409.74df79a3@gandalf.local.home>
In-Reply-To: <20190208134918.5618-6-tstoyanov@vmware.com>
References: <20190208134918.5618-1-tstoyanov@vmware.com>
        <20190208134918.5618-6-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  8 Feb 2019 15:49:16 +0200
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> +static void tracecmd_remove_one_instance(struct buffer_instance *instance)
> +{
> +	char *path;
> +
> +	if (instance->tracing_on_fd > 0) {
> +		close(instance->tracing_on_fd);
> +		instance->tracing_on_fd = 0;

Also note that uninitialized file descriptors should be a negative
number (-1), because zero is a valid descriptor value.

-- Steve

>  	}
> +	path = get_instance_dir(instance);
> +	tracecmd_put_tracing_file(path);
>  }
>  
