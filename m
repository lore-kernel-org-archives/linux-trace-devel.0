Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCD79C07E9B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 20 Jul 2021 22:37:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC2C061208
	for <linux-trace-devel@archiver.kernel.org>; Tue, 20 Jul 2021 22:37:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhGTV4o (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 20 Jul 2021 17:56:44 -0400
Received: from sender4-of-o54.zoho.com ([136.143.188.54]:21422 "EHLO
        sender4-of-o54.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbhGTV4m (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 20 Jul 2021 17:56:42 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1626820609; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=Hz1kxxnbRXbuOLufwAxC39gmuJJb/BtLOvaeaVfOEp8kQxfXa5OtGDRtsqBWCHgh4Lt/RYVSQZYoWf699DXzDweAj0M3UKwsFCyLQfj2mzVGgvJFEL/wzCBBRDKH43YBdMtm17W9pPQddGCil69WmQzFcZz0OPRqFCMNII0QuW8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1626820609; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=S7mrEuBWLRZVVa27UVo9MCN8etsByDL0Idp/L83R+Ic=; 
        b=dxR7kb1/sJlkd/HI8a+q8CxqiCgNyUTmrOv02VgTFJp0y7/pAohtEOPgP/XaZGYayBynx59B8lRDbypd/FqzC599kgsbj27oXJQr9bUudKcz2/VYfO0nMXxaqhW8gjIvSZj34cjHjIo6cY4FbCXoOjMLA8t4PhPAa3Z2VhVd44s=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        spf=pass  smtp.mailfrom=www@aegistudio.net;
        dmarc=pass header.from=<www@aegistudio.net>
Received: from mail.zoho.com by mx.zohomail.com
        with SMTP id 1626820603077860.6478766899824; Tue, 20 Jul 2021 15:36:43 -0700 (PDT)
Date:   Wed, 21 Jul 2021 06:36:43 +0800
From:   contact me <www@aegistudio.net>
To:     "Linus Torvalds" <torvalds@linuxfoundation.org>
Cc:     "Steven Rostedt" <rostedt@goodmis.org>,
        "Ingo Molnar" <mingo@redhat.com>,
        "linux-trace-devel" <linux-trace-devel@vger.kernel.org>,
        "Security Officers" <security@kernel.org>,
        "Haoran Luo" <www@aegistudio.net>
Message-ID: <17ac6106cb2.f47a44f4155575.7075579492521292678@aegistudio.net>
In-Reply-To: <CAHk-=wgFVAtZy9sc98nqujuEh-HqDW5WBvc+MAzobvphY8vZog@mail.gmail.com>
References: <YPaNxsIlb2yjSi5Y@aegistudio> <CAHk-=wgFVAtZy9sc98nqujuEh-HqDW5WBvc+MAzobvphY8vZog@mail.gmail.com>
Subject: Re: [PATCH 1/1] tracing: fix bug in rb_per_cpu_empty() that might
 cause deadloop.
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 21 Jul 2021 02:35:56 +0800 Linus Torvalds <torvalds@linuxfoundation.org> wrote:
 > On Tue, Jul 20, 2021 at 2:04 AM Haoran Luo <www@aegistudio.net> wrote: 
 > > 
 > >         return reader->read == rb_page_commit(reader) && 
 > >                 (commit == reader || 
 > >                  (commit == head && 
 > > -                 head->read == rb_page_commit(commit))); 
 > > +                 (rb_page_commit(commit) == 0 || 
 > > +                  head->read == rb_page_commit(commit)))); 
 > >  } 
 >  
 > Can we please re-write that whole thing to be legible? 
 >  
 > That conditional was complicated before. It's worse now. 
 >  
 > For example, just splitting it up would help: 
 >  
 >  if (reader->read != rb_page_commit(reader)) 
 >  return false; 
 >  
 >  if (commit == reader) 
 >  return true; 
 >  
 >  if (commit != head) 
 >  return false; 
 >  
 >  return !rb_page_commit(commit) || 
 >  commit->read == rb_page_commit(commit); 
 >  
 > but adding comments to each conditional case would also be good. 
 >  
 > Note: I checked "head->read" to "commit->read" in that last 
 > conditional, because we had _just_ verified that "commit" and "head" 
 > are the same, and it seems to be more logical to check "commit->read" 
 > with "rb_page_commit(commit)". 
 >  
 > (And somebody should check that I split it right - I'm just doing this 
 > in the MUA without knowing the code: I hate conditionals that are 
 > cross multiple lines like this, and I hate them particularly when they 
 > turn out to be buggy, so when you fix a complex conditional, that's a 
 > BIG sign to me that the problem was that the conditional was too 
 > complex to begin with). 
 >  
 > Btw, that "rb_page_commit()" forces a new atomic read each time, so 
 > the "rb_page_commit(commit)" value should probably be cached as a 
 > variable before it's used twice. 
 >  
 > Steven? 
 >  
 >  Linus 
 > 

Agreed, this piece of code would be less likely to be buggy if they
are commented by what they are judging. I will do it and send the next
version of patch.
