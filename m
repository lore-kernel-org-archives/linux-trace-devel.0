Return-Path: <SRS0=iTkZ=U3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB639C4321A
	for <linux-trace-devel@archiver.kernel.org>; Fri, 28 Jun 2019 15:55:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C81320828
	for <linux-trace-devel@archiver.kernel.org>; Fri, 28 Jun 2019 15:55:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vYJo4gVQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbfF1Pzq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 28 Jun 2019 11:55:46 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:34384 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726837AbfF1Pzq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 28 Jun 2019 11:55:46 -0400
Received: by mail-io1-f66.google.com with SMTP id k8so13609897iot.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 28 Jun 2019 08:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3G0tBrkJYXAKCUbH0korCidVZwk6CLr64MRDUlBuBGI=;
        b=vYJo4gVQocqcO5Gb1+V+pJdsRfR1jqKmZXl2KqpREIerA4v16NtqQ+F2A2N+cGXTaj
         VpvTW5yJLTsm+TOtcHXlq5mZuUHu4vP4rxdBDc2eAT0EFJ8Sykpq9M3svM11de4d8wrD
         TpLZaiLWoSU1p+5MDWDBHmLbiYA84eSfQ6nMgFQCs9xVEnmm+Bdo2P8UaKdc2lbEqddr
         iEAYphn46AhX+MZ3CvXD1a4LBCF834bPNaHWifJms38/CLMXBqppd6CpNAmZLd2q8eh3
         dqIJ4KmpezmUAejT5xnrPj9maynjL5KTg2yiiykw1F56P5bjWg5yGz2fLe4z0sNj7BvV
         thVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3G0tBrkJYXAKCUbH0korCidVZwk6CLr64MRDUlBuBGI=;
        b=tP8kcpMmQcok+2TXnurpFniuN94z2gfffpMJjHPabo64LLRH1ftE81wEpKIDX0w+Pf
         dvm714JWa+fQEDS3Yob2NMKvYYBioprK7iZFR8Oeiv8tGFXvEnnlsb5uqlOY+j2t5y0U
         Q4nhswaMIc34l+WjbGCVN6J7rhcQKSy22oYoRw/VnSUbzHWhrY1CiukBICBylPtCNbud
         +JfDLSMFxw21h/AIeQyQxe6iDyFlnhF6TvNXM0K5vCWegpdmQRhwTJNxXt2SbSag41U7
         YJh4Py78OkoBzhi0fOZLmL9XGZAzHPYz8NuxlAJgL7YEtqpitK+LxQ2iYHj2PRpfRSwQ
         CrdQ==
X-Gm-Message-State: APjAAAWUSUFJF64cwVknCj9sd0QRz1J0xhdqSturNSGydvjdWz3RqoTJ
        yxOHmlKOO2kFZhsuurLdfsOAXqp0nsKFjJoZ4FbA0g==
X-Google-Smtp-Source: APXvYqz/TctG36FjckWWeBpb0YEYhvz4uQB88XSOkMFuMRy3Qt2Ia26TjSV91XPpqn/ZPy52jvup2l+cym3UDH8TD3c=
X-Received: by 2002:a02:c80d:: with SMTP id p13mr12271388jao.59.1561737345148;
 Fri, 28 Jun 2019 08:55:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190626060101.220607-1-gthelen@google.com> <20190626153401.645b1174@gandalf.local.home>
 <550e11ae-1ac1-dbee-e88b-e62f63a6d032@gmail.com> <20190627121542.2dc0d328@gandalf.local.home>
In-Reply-To: <20190627121542.2dc0d328@gandalf.local.home>
From:   Greg Thelen <gthelen@google.com>
Date:   Fri, 28 Jun 2019 08:55:31 -0700
Message-ID: <CAHH2K0bRs_Vfma-vX9g1mGx-fg+ToLQQ9_Fw8YktZFOi5vxwMw@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd: remove ununsed knuth_hash*() routines
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Jun 27, 2019 at 9:15 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu, 27 Jun 2019 18:40:27 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
>
>
> > Hi Greg,
> >
> > Thanks for the fix!
> >
> > I agree that we have to remove the unused hashing functions, but may I
> > ask you to do a little bit of extra work here.
> > I think that if we are going to keep only one hashing function this
> > function can be called simply knuth_has (not knuth_has8).
>
> Hi Yordan,
>
> Small nit. I think you meant "knuth_hash" not "knuth_has", even though
> I'm sure knuth has a lot ;-)
>
> >
> > Also the comment on top which refers to the TAOCP book must be modified
> > stating that the original idea from the book (32 bit hash) was adapted
> > in order to be used for small tables.
>
> Ack.
>
> -- Steve

Nod.  I'll make these changes and post a patch in a day or so.
