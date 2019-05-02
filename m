Return-Path: <SRS0=5+qO=TC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D7E2C43219
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 May 2019 08:42:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BF9F2075E
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 May 2019 08:42:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dU7gENW1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbfEBIm0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 May 2019 04:42:26 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:52972 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbfEBIm0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 May 2019 04:42:26 -0400
Received: by mail-it1-f194.google.com with SMTP id q65so458698itg.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 May 2019 01:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D808VC5zh5T0iJsWKahnhccRrrHlkvrdmwu9l0KPAkk=;
        b=dU7gENW1mJ49FN6CMitxzDtxNdb4/JEHViOywypD0TkWq82s1zkysWF9x9q6UGMHY5
         ZCJadHkvnO4RCJ/4gxSeNa3KbMTx5O0y/4II8JAj6+Pz+7BZLgLtYw6o9FpK6DGksR+f
         i3iwKpCV9cKe+gt5fCtKB4N/lLRySNxTmW3uGOxKQ+IqOfSaEQNpT4e/HT5vJAvhnG5+
         /gZjtWXSuoOzNutrfqnn6nUewnceXxiQZdcNsappvUqdO4c5ly7LHNOf62pmp7WLHClS
         toumYCV4dCFYn09v0q/EHZfWJ9gG6326C0UUv0hy92jny2fqFNjG9GlHAPqEXCt0kYZI
         3www==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D808VC5zh5T0iJsWKahnhccRrrHlkvrdmwu9l0KPAkk=;
        b=T8oPm+MrgBcnkWVHUaJ53fkLoGjJBMqVxapcy++AWE43siu47Vux9YBts2GGxYXmCp
         hlY2r982nDkIKsz5R4Ipaitlb9WD3oqGmaX+IB59f7+6HyR0tOFAp0x2wofXpMlzXWzf
         0eW+wKKtn6wXzdFfA5bM7cYLb1DClWJfgaj5GquzrFOVZp+/riyslftWHZNLVlVEg178
         MYLX5puSA3DrXY2lAtsq6h2EbOSRCSVmsZwfqOwIPpQPrlbsE6lhTo82KQHRy2vUEFS3
         AeBt6QtNp5fS76JCMzXsi2nTHFc7Tm16jFLPbg8nl36GzCJ4gHB1svfhnTMxG2phzgTf
         xIBQ==
X-Gm-Message-State: APjAAAWYllTIdbX8EbR63ohsb8rpVnE/Gp+HezhUBN1buLajvo2YI+hZ
        hnrjvxK67/ywWXbsB/B5+ZPZniWEUdoE7vzXjw==
X-Google-Smtp-Source: APXvYqy7RSuAbIl1Nb+mtaCqBeYKbSpLufGWGioCa8kmbwb5Yyj1u6uz3yhwgHldR+PFGB12yT8Yg+0jYEeHqUlc3E0=
X-Received: by 2002:a24:35c3:: with SMTP id k186mr1477532ita.92.1556786545541;
 Thu, 02 May 2019 01:42:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190423132741.17864-1-ykaradzhov@vmware.com>
In-Reply-To: <20190423132741.17864-1-ykaradzhov@vmware.com>
From:   Slavomir Kaslev <slavomir.kaslev@gmail.com>
Date:   Thu, 2 May 2019 11:42:14 +0300
Message-ID: <CAE0o1NvX6PDVKu37TzG8=KAvO5yBdfD=EuUoF+VvgKKMxsDBHg@mail.gmail.com>
Subject: Re: [PATCH 0/5] Modifications needed for KS 1.0
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Apr 23, 2019 at 4:28 PM Yordan Karadzhov <ykaradzhov@vmware.com> wrote:
>
> The patch-set contains reimplementation (almost from scratch) of patches
> that have been sent already. The aims is to optimize the workflow of the
> user when running the application from its build (source code) location
> or installation location.
>
> Yordan Karadzhov (5):
>   kernel-shark: Add INSTALL PREFIX to the Cmake-generated header file.
>   kernel-shark: Add logic for the initial path of Open-File dialogs
>   kernel-shark: Add logic for the plugins search path
>   kernel-shark: Remove the definition of KS_DIR
>   kernel-shark: Remember the paths used by the Open-File dialogs.
>
>  kernel-shark/build/deff.h.cmake         |   4 +-
>  kernel-shark/src/KsCaptureDialog.cpp    |  34 ++---
>  kernel-shark/src/KsCaptureDialog.hpp    |   2 +
>  kernel-shark/src/KsMainWindow.cpp       |  81 ++++++------
>  kernel-shark/src/KsMainWindow.hpp       |   6 +-
>  kernel-shark/src/KsUtils.cpp            | 161 ++++++++++++++++++++++--
>  kernel-shark/src/KsUtils.hpp            |  19 +++
>  kernel-shark/src/plugins/CMakeLists.txt |   2 +-
>  8 files changed, 229 insertions(+), 80 deletions(-)

Looks good to me.

Reviewed-by: Slavomir Kaslev <kaslevs@vmware.com>

Cheers,

-- Slavi
