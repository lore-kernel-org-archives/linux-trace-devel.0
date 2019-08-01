Return-Path: <SRS0=bY76=V5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4210C19759
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Aug 2019 14:09:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1AF320679
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Aug 2019 14:09:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731719AbfHAOJx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 1 Aug 2019 10:09:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731377AbfHAOJx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 1 Aug 2019 10:09:53 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FA1320679;
        Thu,  1 Aug 2019 14:09:51 +0000 (UTC)
Date:   Thu, 1 Aug 2019 10:09:49 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Andres Freund <andres@anarazel.de>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH] tools/lib/traceevent, tools/perf: Move struct
 tep_handler definition in a local header file
Message-ID: <20190801100949.1e2f1348@gandalf.local.home>
In-Reply-To: <20190726205544.yffnsfsnji362jk7@alap3.anarazel.de>
References: <20181005122225.522155df@gandalf.local.home>
        <20190726035829.4xcw5k2exx4omlvg@alap3.anarazel.de>
        <20190726091200.0d1e1f01@gandalf.local.home>
        <20190726205544.yffnsfsnji362jk7@alap3.anarazel.de>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 26 Jul 2019 13:55:44 -0700
Andres Freund <andres@anarazel.de> wrote:

> > Care to send a formal patch?  
> 
> Will do.


Hi Andres,

Have you had a chance to send a patch?

Thanks!

-- Steve
