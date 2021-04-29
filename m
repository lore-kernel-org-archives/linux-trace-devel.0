Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 912A2C433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Apr 2021 13:54:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5880161407
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Apr 2021 13:54:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237367AbhD2Ny7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Apr 2021 09:54:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233862AbhD2Ny6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Apr 2021 09:54:58 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB27C61407;
        Thu, 29 Apr 2021 13:54:11 +0000 (UTC)
Date:   Thu, 29 Apr 2021 09:54:10 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 7/7] trace-cmd record: Add new parameter
 --file-version
Message-ID: <20210429095410.48963b4e@gandalf.local.home>
In-Reply-To: <20210429040119.843617-8-tz.stoyanov@gmail.com>
References: <20210429040119.843617-1-tz.stoyanov@gmail.com>
        <20210429040119.843617-8-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 29 Apr 2021 07:01:19 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Added a new optional parameter to "trace-cmd record", can be used to
> select the desired file version of the trace output file.

I'm not sure record should be where a version is specified. Let the user
decide if they can disable a feature that requires a higher version of the
file. That is, if the user does "--no-compression" or whatever we call it,
then it will just save as version 6.

Now what we should do, is to have a conversion command.

 trace-cmd convert <version> <input.dat> <output.dat>

 $ trace-cmd convert 6 trace-7.dat trace-6.dat


We'll just have to document (probably in the convert man page) what
features are added to which version, and how to set up the record to have
it go to a lower version).

-- Steve
