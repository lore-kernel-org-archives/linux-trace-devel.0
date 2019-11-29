Return-Path: <SRS0=Qwo8=ZV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21B92C432C3
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Nov 2019 18:44:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4C0921774
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Nov 2019 18:44:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbfK2Sot (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 29 Nov 2019 13:44:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:33902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726926AbfK2Sot (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 29 Nov 2019 13:44:49 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E70C21736;
        Fri, 29 Nov 2019 18:44:48 +0000 (UTC)
Date:   Fri, 29 Nov 2019 13:44:46 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <slavomir.kaslev@gmail.com>
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] kernel-shark: Retrieve the home of root from
 "/etc/passwd"
Message-ID: <20191129134446.20a0ec3e@oasis.local.home>
In-Reply-To: <CAE0o1Nvd1To0MtBAHdVQgb2g8h5Kh6s08hvxuXAz6fFVAXW-=w@mail.gmail.com>
References: <20191128114500.6289-1-y.karadz@gmail.com>
        <CAE0o1Nvd1To0MtBAHdVQgb2g8h5Kh6s08hvxuXAz6fFVAXW-=w@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 28 Nov 2019 16:27:11 +0200
Slavomir Kaslev <slavomir.kaslev@gmail.com> wrote:

> On Thu, Nov 28, 2019 at 1:46 PM Yordan Karadzhov (VMware)
> <y.karadz@gmail.com> wrote:
> [...]
> > +       auto lamRootHome = [] () {
> > +               QFile fPswd("/etc/passwd");
> > +               QString home("/root");
> > +               QStringList userInfo;
> > +
> > +               fPswd.open(QIODevice::ReadOnly);
> > +               if (!fPswd.isOpen())
> > +                       return home;
> > +
> > +               QTextStream s(&fPswd);
> > +               while (!s.atEnd()) {
> > +                       userInfo = s.readLine().split(':');
> > +
> > +                       /* Check the User Id. */
> > +                       if (userInfo[2].toInt() == 0) {
> > +                               home = userInfo[5];
> > +                               break;
> > +                       }
> > +               }
> > +  
> 
> Another option is to use getpwent(3) [0] instead of parsing /etc/passwd by hand.

Thank you! My google fu is starting to show its age, as I did a bit of
searching looking for a library function to parse passwd, knowing one had
to be there, but came up empty. This is exactly what I was looking for.

Yes, Yordan, I think using this would be the better option as if I had
found it, it would have been what I would have suggested in the first
place.

-- Steve
