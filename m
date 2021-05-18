Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB48FC433B4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 May 2021 13:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7A13611AD
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 May 2021 13:44:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234822AbhERNpx convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 18 May 2021 09:45:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234992AbhERNp2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 18 May 2021 09:45:28 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08B1B6105A;
        Tue, 18 May 2021 13:44:09 +0000 (UTC)
Date:   Tue, 18 May 2021 09:44:08 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 0/7] Final fixes before KS 2.0
Message-ID: <20210518094408.118964bd@gandalf.local.home>
In-Reply-To: <1bc8936b-6ec1-52bd-b292-52464d4ae315@gmail.com>
References: <20210517142140.286153-1-y.karadz@gmail.com>
        <20210517192104.0272eb84@gandalf.local.home>
        <80aafcf7-2ef5-01bd-b417-626e6b10b293@gmail.com>
        <20210518084607.7617ecab@gandalf.local.home>
        <1bc8936b-6ec1-52bd-b292-52464d4ae315@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 18 May 2021 15:58:55 +0300
Yordan Karadzhov <y.karadz@gmail.com> wrote:

> On 18.05.21 г. 15:46, Steven Rostedt wrote:
> >> Unfortunately I am not able to reproduce the crash. maybe it has
> >> something to do with the particular data files you use.  
> > BTW, sometimes I need to do it twice. That is, I hit "Restore Last Session"
> > twice.
> >   
> 
> I restored the session 20 times in a row without having a crash.

Nevermind. I just realized that I was in the process of rebasing your
patches and testing each one when I noticed this bug.

After applying the rest of the patches, I'm not able to reproduce it. I
thought I was done with the rebase (doing too many things in parallel
isn't the best thing :-p).

OK, I think this is good to go (although the col_index looks like it can
still be referenced as a negative).

Sorry for the goose chase on the crash :-/

-- Steve
