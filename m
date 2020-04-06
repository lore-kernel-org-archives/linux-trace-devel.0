Return-Path: <SRS0=vGr1=5W=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8BA4C2BA19
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Apr 2020 14:33:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 962FB23EF6
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Apr 2020 14:33:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BigSGrd6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728630AbgDFOdO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Apr 2020 10:33:14 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46244 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728406AbgDFOdO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Apr 2020 10:33:14 -0400
Received: by mail-pl1-f196.google.com with SMTP id s23so5963278plq.13
        for <linux-trace-devel@vger.kernel.org>; Mon, 06 Apr 2020 07:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=N+16lScq/K94HbX533KDB9IV83/nbtEACUkxQU67O2c=;
        b=BigSGrd62jFLw3dP+CvDe9evmR6L70xPWGvzojYyiHTnQDZBWGkYcahLxaloqLNYYp
         q1qvK/i2HhQNtm0rQFf54cg8hv0AkbbBvd1n7hAEHxHq5tHmEJLT050MTNOLZHNr+1MG
         M8tTKe2g+tuq1Sdhd509be6rbBStSXl1140nK1xANylNLi1cKShs8oatoM/2LrLHI/gw
         gcsBsm6mC5FUXUljIH7Keh7gHu/xvNSaE/ed42n//kieJjNP5xUuoXqSge8GBEnSyD5O
         nDpdvFMXl1vhezeR29In8BsDQl+IbspE60FcJWRpy/nTMN9A3IVGWCceDLqVEgQz6Ir1
         QDig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=N+16lScq/K94HbX533KDB9IV83/nbtEACUkxQU67O2c=;
        b=I1xRkLTaFMhLUSFK/su0IQjnKa+ymnYRjYlT4LJnmubQPCdacPXVdjx5Dip3GU8Par
         HLqqOLWNvEyQniv7WfgWzDNJZjLkGdUMXaXUkL6javZAMHv4+nNVNAlymPrmtmrOuvi6
         435rR2bVXQkkZOoKsACEUhP64NzVkBUrrYG9f3qbPobJrQJ3yhbEy7kEJfnwApezrrfL
         NbK0l/AbWC+6OO4X7ZkwWJ+kRyM+4ykwaiSvpuYfPDNz80AKxImC+Yeo8vFhFwRXxZtK
         wa0hkQzPVc7TECE9/nw9eI8qnXOBc1F0Uh5AYook7VFRCXno6oxyJ55Laq3JI5yWKlMp
         ONpQ==
X-Gm-Message-State: AGi0PuYxCt/HIngLB+VXlAVaLUsL337Cew3nDj/Q6FpcP2VTSbpSi48s
        iY2ZLA8qDdbA4uiScU9EFVK7eE/C0jdaM1a47uJma7crGOM=
X-Google-Smtp-Source: APiQypLZMzSwsAqnN3DgdF8JQbVf8wzY1I4LKhGS+N1E9Z6+u+2Wqu/9X5ieX1+pSVyICA6Vb6lOteH8YjR8LrZtnqw=
X-Received: by 2002:a17:902:b617:: with SMTP id b23mr1600770pls.194.1586183592529;
 Mon, 06 Apr 2020 07:33:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200401164509.191494-1-tz.stoyanov@gmail.com>
 <0f53a13b-f1ff-f467-0f95-899ca404b5b0@gmail.com> <CAPpZLN7NLm=r3y76M1oZAVRh5S7FOCk6-ieSKOzZVtMOCJ=uxQ@mail.gmail.com>
 <5b55ebc5-d682-f934-a643-c0fe65fba003@gmail.com> <CAPpZLN61s-7SY_Ey8Qu7n+=v0FE6VVgxoTp-qrGgit0=Rj_0SQ@mail.gmail.com>
 <3e45fc77-619f-3d3e-3f48-47d0fcf29f1d@gmail.com>
In-Reply-To: <3e45fc77-619f-3d3e-3f48-47d0fcf29f1d@gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 6 Apr 2020 17:33:00 +0300
Message-ID: <CAPpZLN5d4Q9k48hoC=VBTAs3g=KGTL11f_dT+5HYVf1jwq6NJw@mail.gmail.com>
Subject: Re: [PATCH] kernel-shark-2.alpha: Use new tracecmd API to open guest
 tracing file
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Apr 6, 2020 at 4:24 PM Yordan Karadzhov (VMware)
<y.karadz@gmail.com> wrote:
>
>
>
> On 3.04.20 =D0=B3. 20:12 =D1=87., Tzvetomir Stoyanov wrote:
> >> Maybe it has to be a bit more sophisticated. Does the "primary" stream
> >> know how to recognize its "secondary" streams?
> >>
> > Yes, there are tracing IDs in both host and guest files. When these IDs=
 match,
> > files are from a same tracing session.
> > I can add "parent_stream_id" member in "struct kshark_data_stream" and
> > initialize it
> > when reading the files, according to the trace IDs.
>
> Not sure if this is the right place to put this information. I do not
> want to have "tep data" specific fields in "struct kshark_data_stream".
> Is it possible to have this mapping stored in in "struct tepdata_handle"
> instead.
Actually, the only new thing in "struct kshark_data_stream" will be the id =
of
the parent stream, "int parent_stream_id". All tracecmd specific mappings a=
re in
"struct tracecmd_input" and will be accessible via tracecmd APIs.
Currently I assume that the stream with ID 0 is parent to all other
streams, opened with "-a" option.
This assumption will be removed when this "parent_stream_id" is introduced.

>
> Thanks!
> Yordan



--=20
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
