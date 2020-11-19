Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5656C5519F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Nov 2020 01:11:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76DEA24692
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Nov 2020 01:11:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgKSBLi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 18 Nov 2020 20:11:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:46764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726739AbgKSBLi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 18 Nov 2020 20:11:38 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDA2422260;
        Thu, 19 Nov 2020 01:11:36 +0000 (UTC)
Date:   Wed, 18 Nov 2020 20:11:34 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 08/20] kernel-shark: Add stream interface for
 trace-cmd data
Message-ID: <20201118201134.267cfcfe@oasis.local.home>
In-Reply-To: <20201118145003.156542-9-y.karadz@gmail.com>
References: <20201118145003.156542-1-y.karadz@gmail.com>
        <20201118145003.156542-9-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 18 Nov 2020 16:49:51 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> +static char *tepdata_get_task(struct kshark_data_stream *stream,
> +			      const struct kshark_entry *entry)
> +{
> +	struct kshark_generic_stream_interface *interface = stream->interface;
> +	const char *task;
> +	char *buffer;
> +	int pid;
> +
> +	if (!interface)
> +		return NULL;
> +
> +	pid = interface->get_pid(stream, entry);
> +	task = tep_data_comm_from_pid(kshark_get_tep(stream), pid);


> +	if (asprintf(&buffer, "%s", task)  <= 0)
> +		return NULL;
> +
> +	return buffer;

That's a pretty fancy way to implement:

	return strdup(task ? : "(nil)");

 ;-)

If you wanted to show "(nil)" when task is NULL.

Otherwise, if you want to return NULL if task is NULL, then you could
simplify it further to just:

	return task ? strdup(task) : NULL;


-- Steve


> +}
