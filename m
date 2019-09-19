Return-Path: <SRS0=Eaid=XO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C972FC3A5A6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Sep 2019 23:20:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0AF2217D6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Sep 2019 23:20:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390868AbfISXUZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Sep 2019 19:20:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:34956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389376AbfISXUZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Sep 2019 19:20:25 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4ADA4214AF;
        Thu, 19 Sep 2019 23:20:24 +0000 (UTC)
Date:   Thu, 19 Sep 2019 19:20:22 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org, stephen@brennan.io
Subject: Re: [PATCH v2 1/3] kernel-shark: Provide parsing for quotation
 marks in Record command line
Message-ID: <20190919192022.7b9d8918@gandalf.local.home>
In-Reply-To: <20190918142319.11821-2-y.karadz@gmail.com>
References: <20190918142319.11821-1-y.karadz@gmail.com>
        <20190918142319.11821-2-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 18 Sep 2019 17:23:17 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> +/**
> + * Separate the command line arguments inside the string taking into account
> + * possible shell quoting and new lines.
> + */
> +QStringList splitArguments(QString cmd)
> +{
> +	QString::SplitBehavior opt = QString::SkipEmptyParts;
> +	int i, progress = 0, size;
> +	QStringList argv;
> +	QChar quote = 0;
> +
> +	/* Remove all new lines. */
> +	cmd.replace("\\\n", " ");
> +
> +	size = cmd.count();
> +	auto lamMid = [&] () {return cmd.mid(progress, i - progress);};
> +	for (i = 0; i < size; ++i) {
> +		if (cmd[i] == '\\') {
> +			cmd.remove(i, 1);
> +			size --;
> +			continue;
> +		}
> +
> +		if (cmd[i] == '\'' || cmd[i] == '"') {
> +			if (quote.isNull()) {
> +				argv << lamMid().split(" ", opt);
> +				quote = cmd[i++];
> +				progress = i;
> +			} else if (quote == cmd[i]) {
> +				argv << lamMid();
> +				quote = 0;
> +				progress = ++i;
> +			}
> +		}
> +	}
> +
> +	argv << cmd.right(size - progress).split(" ", opt);
> +
> +	return argv;
> +}

I still find the above hard to read, but so be it ;-) 

Anyway, not quite yet. I just noticed that if I do:

  echo "this \" is \" a \"test"

The output has:

("echo", "this \" is \" a \"test")


We don't want to keep the backslash here. We want to remove it before
passing it as an argument.

The above should be:

("echo", "this " is " a "test")

(thinking that you put in the outside quotes. In other words, if I have:

 echo "hello \"there\""

We should break that up into: 
  arg0=echo
  arg1=hello "there"

-- Steve

