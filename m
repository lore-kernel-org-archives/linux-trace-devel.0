Return-Path: <SRS0=byw1=VC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13240C4649B
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Jul 2019 14:25:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2F7E2133F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Jul 2019 14:25:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pdx+TCiS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725681AbfGEOZl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Jul 2019 10:25:41 -0400
Received: from mail-ua1-f67.google.com ([209.85.222.67]:39957 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbfGEOZl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Jul 2019 10:25:41 -0400
Received: by mail-ua1-f67.google.com with SMTP id s4so2261414uad.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Jul 2019 07:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J0EK4b6b4llkkXrTgxO6nryz9emb6kCH9Qdq0KF68qA=;
        b=pdx+TCiS3i4z6iNu+xSATSIDo3EfJIPzkVwTLOK9GmK172oAEZi05Ih7V0gA1UfefF
         goMPyzWYOrJaNo/7q/OKcLujh1m0mbYgC3IBS12iIYFGTu3I+tg1Md+ynxIlxzlNNGqN
         z7GKqYBX8/4DdcyPl95R+z3p+jCbU0hysM2S0Q6FmD5unl4tytpsWrxpcwg7E5mG3Cyq
         j1GP783wZH4pH4TBZrsimZ5VDkP3OSg21yqPvMdDbRgibD6CkaQ0LtgpigVOL46y120l
         JfmP8M5h9VM4IgBnm5vgPFfsVvxqVmbWT/iCnDINx1HjdDtRzFLr0PIn2gH8djPKLL9T
         i+sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J0EK4b6b4llkkXrTgxO6nryz9emb6kCH9Qdq0KF68qA=;
        b=Csl6sI8dHc40usYciPAMy8+XXba5TpIGjSOrbiXc6yjhYm6ujuTyGsZxK/Vdb3IOT+
         G7TbVOWafOUeWjddSXMxy6rIW6D4vW8m8Juc3EDuRSyo44tf4bi63hxJve1Z1ipuOlee
         tQBGQlR0RxUawXz1Nm99J1b1Dd/5jun7n9BVhB/fzPD+ji5n5vKqYLcTB+/AdyW2C0L3
         o9coTRyxyXxfdzGrIQOIRshusUd1djvGMDhNyjsIq+7X5Z1rqw/v7ioWppGqXRBv1ygP
         MrXDHh/9x2rCEz5BnxAsffUTT7mc3bZ/UOszg6awl7tu0lpyKhJcBYKbV6ggeBvNaHEd
         UuFg==
X-Gm-Message-State: APjAAAW3RaWnAxAwptE5cclF2pL16WdMs36f8WHp7V8zYbquQbaJ++5J
        fWESEvv0LN7VTc7H4ErEXW8rogeZx+4NW0GlHA==
X-Google-Smtp-Source: APXvYqxQgJpjufhkv4RSNL2l7PUfZw25gnFm2TVLmF8MaZGM25rBipyTVkb3HzkhiwKL7OvSkdGZ8hgyvqTvstbt33Q=
X-Received: by 2002:ab0:734f:: with SMTP id k15mr2109031uap.28.1562336740457;
 Fri, 05 Jul 2019 07:25:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190705141031.20239-1-y.karadz@gmail.com>
In-Reply-To: <20190705141031.20239-1-y.karadz@gmail.com>
From:   Slavomir Kaslev <slavomir.kaslev@gmail.com>
Date:   Fri, 5 Jul 2019 17:25:29 +0300
Message-ID: <CAE0o1Nt8M=xsF_pX49yDxDfvemowjp_Cbe2v3YG=yBbEMrTnNA@mail.gmail.com>
Subject: Re: [PATCH 0/2] Fixes needed befor KS 1.0
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Jul 5, 2019 at 5:16 PM Yordan Karadzhov (VMware)
<y.karadz@gmail.com> wrote:
>
> Yordan Karadzhov (VMware) (2):
>   kernel-shark: Line up the table of the loaded Advanced filters
>   kernel-shark: Separate the target instalation instructions
>
>  kernel-shark/src/CMakeLists.txt           | 6 +++++-
>  kernel-shark/src/KsAdvFilteringDialog.cpp | 2 +-
>  2 files changed, 6 insertions(+), 2 deletions(-)
>
> --
> 2.20.1
>

Both patches look good to me.

Reviewed-by: Slavomir Kaslev <kaslevs@vmware.com>

Cheers,

-- Slavi
