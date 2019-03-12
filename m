Return-Path: <SRS0=WSgK=RP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE564C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Mar 2019 19:23:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5A63214AE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Mar 2019 19:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbfCLTXV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Mar 2019 15:23:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:59798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726284AbfCLTXV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Mar 2019 15:23:21 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7795A2077B;
        Tue, 12 Mar 2019 19:23:20 +0000 (UTC)
Date:   Tue, 12 Mar 2019 15:23:19 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: Re: [RFC PATCH v8 07/13] trace-cmd: Add VM kernel tracing over
 vsockets transport
Message-ID: <20190312152319.3e83e1e7@gandalf.local.home>
In-Reply-To: <20190222180539.27439-8-kaslevs@vmware.com>
References: <20190222180539.27439-1-kaslevs@vmware.com>
        <20190222180539.27439-8-kaslevs@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 22 Feb 2019 20:05:33 +0200
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> +static void read_qemu_guests(void)
> +{
> +	static bool initialized;
> +	struct dirent *entry;
> +	char path[PATH_MAX];
> +	DIR *dir;
> +
> +	if (initialized)
> +		return;
> +
> +	initialized = true;
> +	dir = opendir("/proc");
> +	if (!dir)
> +		die("opendir");

I would at least say:

		die("Can not open /proc");

That way, the user has of the error, as a message of just "File or
directory does not exist: opendir", isn't very helpful.

-- Steve
