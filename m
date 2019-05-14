Return-Path: <SRS0=/f37=TO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5A03C04AB4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 May 2019 15:50:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8351020879
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 May 2019 15:50:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbfENPuA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 May 2019 11:50:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725901AbfENPt7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 May 2019 11:49:59 -0400
Received: from oasis.local.home (50-204-120-225-static.hfc.comcastbusiness.net [50.204.120.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 534ED2086A;
        Tue, 14 May 2019 15:49:58 +0000 (UTC)
Date:   Tue, 14 May 2019 11:49:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 01/27] tools lib traceevent: Remove hard coded install
 paths from pkg-config file
Message-ID: <20190514114957.663454b0@oasis.local.home>
In-Reply-To: <20190514150524.GA1756@kernel.org>
References: <20190510195606.537643615@goodmis.org>
        <20190510200105.966709757@goodmis.org>
        <20190510161150.20be7f1e@gandalf.local.home>
        <BDB00110-43B1-4766-BB21-D7BF6FDD5EC7@kernel.org>
        <20190514150524.GA1756@kernel.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 14 May 2019 12:05:24 -0300
Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com> wrote:

> > >Arnaldo,
> > >
> > >I believe you already applied patch 1 (otherwise I would not have your
> > >SOB on it), please ignore. But patch 2 on are new to be applied.  
> > 
> > 
> > Ok, I'll be back at work early next week and will peixes this,  
> 
> Done.

Thanks Arnaldo!

-- Steve
