Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AE8EC4338F
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 02:49:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B5F560FA0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 02:49:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233484AbhHCCtT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 2 Aug 2021 22:49:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:35980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233436AbhHCCtT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 2 Aug 2021 22:49:19 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7CC960E09;
        Tue,  3 Aug 2021 02:49:07 +0000 (UTC)
Date:   Mon, 2 Aug 2021 22:49:00 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Namhyung Kim <namhyung@kernel.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 01/17] libtracefs: Added new API tracefs_sql()
Message-ID: <20210802224900.20c2b419@oasis.local.home>
In-Reply-To: <CAM9d7cieXRLU3huWVSha-A=CvumEFq59QU_pXYDkeBNS3m_mRA@mail.gmail.com>
References: <20210730221824.595597-1-rostedt@goodmis.org>
        <20210730221824.595597-2-rostedt@goodmis.org>
        <CAM9d7cieXRLU3huWVSha-A=CvumEFq59QU_pXYDkeBNS3m_mRA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 2 Aug 2021 16:45:39 -0700
Namhyung Kim <namhyung@kernel.org> wrote:

> > +%option caseless
> > +
> > +field          [a-z_][a-z0-9_\.]*
> > +qstring                \"[^\"]*\"
> > +hexnum         0x[0-9a-z]+
> > +number         [0-9a-z]+  
> 
> Do you mean a-f ?

Doh! Thanks, I'll fix that up for v2.

-- Steve
