Return-Path: <SRS0=h6jj=SV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DATE_IN_PAST_06_12,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5E1FC282DA
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 19:23:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EE7620821
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 19:23:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y2EgPQrK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbfDSTXa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Apr 2019 15:23:30 -0400
Received: from mail-it1-f179.google.com ([209.85.166.179]:50486 "EHLO
        mail-it1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727394AbfDSTXa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Apr 2019 15:23:30 -0400
Received: by mail-it1-f179.google.com with SMTP id q14so2178191itk.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 19 Apr 2019 12:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7Kv2B3HOjY4ocxdFqBBr4vUWPvPCN+eWliCGMvHNqSM=;
        b=Y2EgPQrKLLqibhut53t2XepUrG9nkgcqtgHUQ+9PJgLUvClT0SqGkS6pIW8iuGwBOv
         0toiqQPI4Smvoc56XzhN3bh5MTjjDKqqpqpTuj5aYxeIQQeUpsWHUPB7i9/xfhlztqnx
         wgCD3Akam7lJXSXbAi2bHS9fHSB01rfitbNe3yHttVRP2RBSz3A+pxswJn+VUWUo2NnE
         nNE00uCbDxwNfT2Cfk+EZdZVCEwX28vWHtQnYSdknSE65xmEyZbzVkDfRcfiTrjQxX5z
         h0E//P1R2nx9LEzMpVegg3+/3FoDQaUTt71NpYZi2gOBWG1+6jvL8FVqejKtNM9kb3po
         GHZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7Kv2B3HOjY4ocxdFqBBr4vUWPvPCN+eWliCGMvHNqSM=;
        b=WWbBXESazcVeQyWavqVG5v4XU3PL6TSxYpDuZQ7JTxw8ml5Uj7WZG58yEtIDmkf2i6
         IDoyUgwr/C9dGpWeD3bbWJR9/PMrmWs76lO700hCF3Pv/wuv4m8XCTcmOyJ2aaPjh8EI
         khR7PfZCZKTA+je1e9rfHShIgdEm7gyKSHrFIVR4nIw+aO3UBLJxEPpzDxztwUjR+Pgw
         0/1ZYCzs0k2bMgq3eRWNq23Z+dyYvh+LKk2pLXmYnGlSJ2AAiPDHfvq9iaF87dYMh/LM
         OYNtzsLyqkQxMkM0bjSHi8pEn6gSkrF8/Rr23wnoz0iUi4zLGmVq8mF5UVxkrKNBivUt
         V8RA==
X-Gm-Message-State: APjAAAW0SkvwY0Tkfno0882D8PEKfwS/nGhSVWur5H1tk4iReZ3AZHMq
        oYLbMW4buFYLF5Y+wFSnPTyoKrrC6iiPK5pyV64tk2dPNQ==
X-Google-Smtp-Source: APXvYqw5gKOf6bZ5P7XtTUTKNtm0EsOxxZLqIWJ58BkEB1SCsW/uTQT1QI/iZlV6ir7sCkff89j2QkPEir+3SbH0IbQ=
X-Received: by 2002:a24:108b:: with SMTP id 133mr1931818ity.15.1555661287040;
 Fri, 19 Apr 2019 01:08:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190418152146.27232-1-ykaradzhov@vmware.com> <20190418152146.27232-9-ykaradzhov@vmware.com>
 <CAE0o1NtiXyL9RW2+t6mS2nXkH=ZQz2vukDMz3f4dTiLBxJG+8w@mail.gmail.com> <b0021d24-65c0-7e97-6c23-a13732bc7760@vmware.com>
In-Reply-To: <b0021d24-65c0-7e97-6c23-a13732bc7760@vmware.com>
From:   Slavomir Kaslev <slavomir.kaslev@gmail.com>
Date:   Fri, 19 Apr 2019 11:07:55 +0300
Message-ID: <CAE0o1Nvw_Ef-XSAVzMHmfa-3+gBQzutSfTj_mc-FsJ41GQFXkA@mail.gmail.com>
Subject: Re: [PATCH v2 8/8] kernel-shark: Handle the case when the marker
 points to a filtered entry
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Apr 19, 2019 at 10:46 AM Yordan Karadzhov <ykaradzhov@vmware.com> w=
rote:
>
>
>
> On 19.04.19 =D0=B3. 10:29 =D1=87., Slavomir Kaslev wrote:
> > On Thu, Apr 18, 2019 at 6:23 PM Yordan Karadzhov <ykaradzhov@vmware.com=
> wrote:
> >>
> >> Markers can point to entries that are filtered out. When switching
> >> the marker it may happen that new Active Marker points to an entry
> >> that is filtered. In this case no actions must be taken and a warning
> >> message for the user must be displayed.
> >>
> >> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> >> ---
> >>   kernel-shark/src/KsTraceViewer.cpp | 27 +++++++++++++++++----------
> >>   kernel-shark/src/KsTraceViewer.hpp |  2 ++
> >>   2 files changed, 19 insertions(+), 10 deletions(-)
> >>
> >> diff --git a/kernel-shark/src/KsTraceViewer.cpp b/kernel-shark/src/KsT=
raceViewer.cpp
> >> index 04a38b8..85da64f 100644
> >> --- a/kernel-shark/src/KsTraceViewer.cpp
> >> +++ b/kernel-shark/src/KsTraceViewer.cpp
> >> @@ -61,7 +61,8 @@ KsTraceViewer::KsTraceViewer(QWidget *parent)
> >>     _graphFollowsCheckBox(this),
> >>     _graphFollows(true),
> >>     _mState(nullptr),
> >> -  _data(nullptr)
> >> +  _data(nullptr),
> >> +  _em(this)
> >>   {
> >>          this->setSizePolicy(QSizePolicy::Preferred, QSizePolicy::Maxi=
mum);
> >>
> >> @@ -493,15 +494,21 @@ void KsTraceViewer::markSwitch()
> >>                  QModelIndex index =3D
> >>                          _proxyModel.mapFromSource(_model.index(row, 0=
));
> >>
> >> -               /*
> >> -                * The row of the active marker will be colored accord=
ing to
> >> -                * the assigned property of the current state of the D=
ual
> >> -                * marker. Auto-scrolling is temporarily disabled beca=
use we
> >> -                * do not want to scroll to the position of the marker=
 yet.
> >> -                */
> >> -               _view.setAutoScroll(false);
> >> -               _view.selectRow(index.row());
> >> -               _view.setAutoScroll(true);
> >> +               if (index.isValid()) {
> >> +                       /*
> >> +                        * The row of the active marker will be colore=
d according to
> >> +                        * the assigned property of the current state =
of the Dual
> >> +                        * marker. Auto-scrolling is temporarily disab=
led because we
> >> +                        * do not want to scroll to the position of th=
e marker yet.
> >> +                        */
> >> +                       _view.setAutoScroll(false);
> >> +                       _view.selectRow(index.row());
> >> +                       _view.setAutoScroll(true);
> >> +               } else {
> >> +                       _view.clearSelection();
> >> +                       QString err("The marker's entry is filtered ou=
t.");
> >> +                       _em.showMessage(err);
> >
> > When is this error message going to be cleared? I don't think it
> > changes atm unless a new error comes along.
>
> The message will be displayed in a small widget (QErrorMessage). This
> widget has an "OK" button and a "Show this message again" checkbox.
>
> To clear the message you can either press "OK" or close the widget.
> If you uncheck the "Show this message again" checkbox, no message will
> be shown next time when the error occurs.

That makes sense. In that case, the patch lgtm

Reviewed-by: Slavomir Kaslev <kaslevs@vmware.com>

Cheers,

-- Slavi
