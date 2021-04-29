Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DB1CC433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Apr 2021 01:26:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 355006143E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Apr 2021 01:26:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233101AbhD2B1G convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 21:27:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:59846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231564AbhD2B1F (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 21:27:05 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 000286143E;
        Thu, 29 Apr 2021 01:26:19 +0000 (UTC)
Date:   Wed, 28 Apr 2021 21:26:18 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 6/6] trace-cmd record: Add new parameter --file-version
Message-ID: <20210428212618.41262613@oasis.local.home>
In-Reply-To: <20210422071718.483383-7-tz.stoyanov@gmail.com>
References: <20210422071718.483383-1-tz.stoyanov@gmail.com>
        <20210422071718.483383-7-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 22 Apr 2021 10:17:18 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Added a new optional parameter to "trace-cmd record", can be used to
> select the desired file version of the trace output file.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>

Even with this last patch, I still get:

trace-input.c: In function ‘tracecmd_get_file_version’:
trace-input.c:4033:15: error: ‘struct tracecmd_input’ has no member named ‘file_version’
 4033 |  return handle->file_version;
      |               ^~
trace-input.c:4034:1: warning: control reaches end of non-void function [-Wreturn-type]
 4034 | }

So you must have added a change without somehow committing it :-/

-- Steve
