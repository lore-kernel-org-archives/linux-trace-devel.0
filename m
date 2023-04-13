Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8622C77B6E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Apr 2023 12:18:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjDMMRc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 Apr 2023 08:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbjDMMRa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 Apr 2023 08:17:30 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F6C448F
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 Apr 2023 05:17:29 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id dd8so2294668qvb.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 Apr 2023 05:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681388248; x=1683980248;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=epAiGoHWx109IMEaEVrXkijNvH1wZICfjpQ5X3V2TUI=;
        b=XvZMX/+oebDsVaZUEB6Y1rWpMpfIyF1WnAjS+2y91M2TOHmtl8ya19irm8Kvhzqvvz
         GPcO7s+nQVYErXieiNK0VWzWTOvFt4wbEz9IgZzJE7wWjtVcC9eRw/QsG7ldK6NcsIjF
         LPBF/SUMW6tLOPTmI5FTl2jFYpGzcpPsoYpM5Z6Gmn95HDC7ml5E6xzJlnwTRw7Mibt8
         OzSxy77XDBEj5BkQgq2EV7V1af1eVAPCYnAJdW6nO8DXyTQVVczKSkz+2/UY5uaFTLe3
         R8m55IrygYegKVw1e2lpukVfaaM1I/Q8KyHlqyWIAOarw/MvIhCAxyaLycyMGstDHpJs
         3J0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681388248; x=1683980248;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=epAiGoHWx109IMEaEVrXkijNvH1wZICfjpQ5X3V2TUI=;
        b=Zqby7+bh2+E7vMgdcJvyY2G4OoiyvSWx8/2rHlOLqC+VygJa/u62kNaUHj4pSHOzRG
         rS8g4ePwT/Bx5n9qnP498b7k2aYfQl2hidMPLMALg19uKvvKfGNyx52UrRV2gKPi/P9r
         SHY5326Gk23dFMQpfbYG2BEaBNIDbWmxQKrkmtI8P1n2apxszKg9wcakgl//zMWS5Win
         4A5WqYGI20EAZbGocBEgY2mOvPVHHPiftmEqycgo+F20aUJ4aWnE/8wWAF+mt4MUymBg
         mhc8jnf36/57KtyW4lEeI8iGugmfDBWYkwgaBKw6QbipvL8F10YDvxnLqvL8Qv+I2Hgo
         XfLg==
X-Gm-Message-State: AAQBX9fFTSFw6QLSLkyJPd0sjxPJf+w5z4DrjGDKACN7RfdIvdtaiGM0
        fquu1jjcKAaFw3jDPoSzLIuNdvJKWeFoifbKZl9MsICxHH0=
X-Google-Smtp-Source: AKy350avFNPVCE6Avq1Jy+d/iE1uBE/zfyx3azt+IvH9guqzcBkk/JGx/Usw4UZqbpLwPzDZlL3UtDftnaR8lcX5cTU=
X-Received: by 2002:a05:6214:933:b0:5ef:4789:6c33 with SMTP id
 dk19-20020a056214093300b005ef47896c33mr437321qvb.2.1681388248213; Thu, 13 Apr
 2023 05:17:28 -0700 (PDT)
MIME-Version: 1.0
References: <20230328150308.34783-1-tz.stoyanov@gmail.com> <20230328111331.1e9cb292@gandalf.local.home>
In-Reply-To: <20230328111331.1e9cb292@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 13 Apr 2023 15:17:11 +0300
Message-ID: <CAPpZLN7E4hFL-a1Eg5Gc3=fpyyPW8S+Gp+xrmD48hqnK2YCsoA@mail.gmail.com>
Subject: Re: [PATCH 0/3] Introduce new API to reset ftrace instance
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Mar 28, 2023 at 6:13=E2=80=AFPM Steven Rostedt <rostedt@goodmis.org=
> wrote:
>
> On Tue, 28 Mar 2023 18:03:05 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > A new API tracefs_instance_reset() for resetting instance to its defaul=
t
> > state, based on the logic from "trace-cmd reset" command.
>
> HAH!!!
>
> I was just thinking that I needed to implement this earlier today.
>
> I'm so happy when someone else does my work for me :-D
>
> Thanks Tzvetomir, I'll hopefully get a chance to review this sometime thi=
s
> week.

ping
Did you have time to take a look at these patches? I'm planing to use
the library in a new project and need this new functionality.

>
> -- Steve
>
> >
> > Tzvetomir Stoyanov (VMware) (3):
> >   libtracefs: New API to reset ftrace instance
> >   libtracefs: Documentation for tracefs_instance_reset()
> >   libtracefs: Unit test for tracefs_instance_reset()
> >
> >  Documentation/libtracefs-instances-manage.txt |   7 +-
> >  Documentation/libtracefs.txt                  |   1 +
> >  include/tracefs-local.h                       |   1 +
> >  include/tracefs.h                             |   1 +
> >  src/tracefs-instance.c                        | 196 ++++++++++++++++++
> >  src/tracefs-utils.c                           |  20 ++
> >  utest/tracefs-utest.c                         | 183 ++++++++++++++++
> >  7 files changed, 407 insertions(+), 2 deletions(-)
> >
>


--=20
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
