Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 841BCC433DB
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Mar 2021 22:18:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8243161A2A
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Mar 2021 22:18:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhCZWSE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 26 Mar 2021 18:18:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230043AbhCZWRy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 26 Mar 2021 18:17:54 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A51CE61A26;
        Fri, 26 Mar 2021 22:17:53 +0000 (UTC)
Date:   Fri, 26 Mar 2021 18:17:51 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org, stefano.devenuto99@gmail.com
Subject: Re: [PATCH v33 5/5] trace-cmd [POC]: Add KVM timestamp
 synchronization plugin
Message-ID: <20210326181751.6b3233a3@gandalf.local.home>
In-Reply-To: <20210325071413.543640-6-tz.stoyanov@gmail.com>
References: <20210325071413.543640-1-tz.stoyanov@gmail.com>
        <20210325071413.543640-6-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 25 Mar 2021 09:14:13 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +static int read_ll_form_file(char *file, long long *res)

Is this reading a ll form file, or is this suppose to be read ll from file?

> +{
> +	char buf[32];
> +	int ret;
> +	int fd;
> +
> +	if (!file)
> +		return -1;
> +	fd = open(file, O_RDONLY | O_NONBLOCK);
> +	if (fd < 0)
> +		return -1;
> +	ret = read(fd, buf, 32);
> +	close(fd);
> +	if (ret <= 0)
> +		return -1;
> +
> +	*res = strtoll(buf, NULL, 10);

Also, if for some reason this file produced hex this wont work. Should we
just let it detect the format?

	*res = strtoll(buf, NULL, 0);

This way both "10" and "0xa" would produce the same result.

-- Steve


> +
> +	return 0;
> +}
