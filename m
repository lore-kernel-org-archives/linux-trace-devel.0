Return-Path: <SRS0=jdea=3M=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E8C7C2D0DB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 Jan 2020 21:11:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D762021D7D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 Jan 2020 21:11:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mm4+TEP2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbgAWVLc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 23 Jan 2020 16:11:32 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38890 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgAWVLc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 23 Jan 2020 16:11:32 -0500
Received: by mail-pl1-f194.google.com with SMTP id t6so1884823plj.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 23 Jan 2020 13:11:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UKPkE8t0LQZGWZRdEHnmeLD2W8+2CSRAeN+0iJOc0dE=;
        b=mm4+TEP2izKRW2F+7w3NErDckfFO86Ezgdsjl+TOPRRdoJs1eBLIfe1AWibBHTmPUW
         n6TJ52A4+RTnlpBTnQezkDg/n1eBRDibZ5aOG5cauLatIlsN6RTCYNlJhjKosGwwJOZx
         taSFXeDMRMYYhpyoiROX7zzmBSFwUZwjr2pRXEPzxBNBDIeP05Ecr+sv9h8XLeGL+lHg
         uJftSuxeR5NATQzLTmguXrsnYNSqFOjLW2BmRv4otDw6u2THXzNDb2ZMCnJ/Obr67wle
         pe5RBxeALmJDe6VQMwCMCG1fcYVy/0X/v6fJ20fmIkZFUD2rJBz09FLzUpVIK8AhDISt
         V+VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UKPkE8t0LQZGWZRdEHnmeLD2W8+2CSRAeN+0iJOc0dE=;
        b=gcBD76qkRebce7ygaXhSikKuSWGW9vUIgGrl2Fm46piM9slmKWpiiYOp+Bmt/JqjJO
         ZMvPtRmBPjk6xQySRMIU6kI1/a6XM8W9VXkVJTCOmWrtyTKIRap69cs2u6AM55stoH1i
         eBr9659YB0un0KqYUWZAPQS8ap4uhkffH+A85mIM8LwHIxwUS99EB42Z+PVa7KxtIPZf
         F+3hA3uhuFezfOG/MCfKtIgN/dCyUbV2uNroPdqqgqFSGcDRmGLssk4l5sOtQiryY8An
         t2sZu6XcZ9n1HBP2SisS24d3gPPmeCXYLLqsOe9tEZBstT+CJl7U9cssZtUo42ByHLo/
         xWWw==
X-Gm-Message-State: APjAAAWt+QzydzjGrQBzMLsdA5UZND5e6YRvG5Wr5T9bFwi14jHQJFGF
        sHkU3NOygFb0ybxt/y/asEbz16bEtsfx8xAq9O/Tn0a9
X-Google-Smtp-Source: APXvYqzkPeQhjBfYpQ0t2417ayvU89sl8SImdW3SqCaGTOuKC3JtnvevZ87APhlltZ3vbJjpDgfVyoN0KVS8lUYXPW0=
X-Received: by 2002:a17:90a:31cf:: with SMTP id j15mr6736168pjf.120.1579813891578;
 Thu, 23 Jan 2020 13:11:31 -0800 (PST)
MIME-Version: 1.0
References: <20200112190537.170197-1-marcgonzalez@google.com>
 <20200120173335.7ec9609f@rorschach.local.home> <CAKvFj6o5gTRHFwjFdQJh4K-t-tdGdag6NHCjXYpW=29-yqHWww@mail.gmail.com>
 <20200122122805.0ecfdb1f@gandalf.local.home> <CAKvFj6qxHBHk3G61qqo8vMeu9JFQ_3VuiwJZs4X8EBfYX00sag@mail.gmail.com>
 <20200122140830.2111942e@gandalf.local.home> <CAKvFj6odA2Ac2NvQ5zzc3=4wG18uXc-ECEQDWr+wjpS8G1TGiA@mail.gmail.com>
 <20200123160825.256d5be4@gandalf.local.home>
In-Reply-To: <20200123160825.256d5be4@gandalf.local.home>
From:   Marcelo Diop-Gonzalez <marcgonzalez@google.com>
Date:   Thu, 23 Jan 2020 16:11:20 -0500
Message-ID: <CAKvFj6r3MSyhL05U7P0-TECQhRsR0MeX7dWhm4aDsuZUwdr+2g@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd: generate cscope.files when building cscope index
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Jan 23, 2020 at 4:08 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu, 23 Jan 2020 14:51:53 -0500
> Marcelo Diop-Gonzalez <marcgonzalez@google.com> wrote:
>
> > On Wed, Jan 22, 2020 at 2:08 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> > >
> > > On Wed, 22 Jan 2020 13:49:40 -0500
> > > Marcelo Diop-Gonzalez <marcgonzalez@google.com> wrote:
> > > >
> > > > > then I'm OK with your approach, but we need to make sure we update
> > > > > the .gitignore and clean make target to remove it.
> > > >
> > > > Ah good point! I'll send out another version if this way's the way to go.
> > >
> > > Yes, please do. Thanks!
> >
> > Ah actually, should these be covered by the 'cscope* ' lines in
> > .gitignore and the clean make target?
> >
>
> Ah, I guess they are ;-)
>
> OK, I'll take your original patch. Thanks!

Sounds good, thanks!

-Marcelo
>
> -- Steve
