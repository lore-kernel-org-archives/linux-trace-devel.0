Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DD63C7EE2E
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 May 2023 08:19:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjE3IT6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 May 2023 04:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbjE3ITr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 May 2023 04:19:47 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEFA6AD
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 May 2023 01:19:44 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id d75a77b69052e-3f8177f9a7bso14720521cf.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 May 2023 01:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685434784; x=1688026784;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cBHIkC3AgOkCXlgQJMZIKeQ+JgiscMmgY3/0dKa5Q1s=;
        b=NKtRGwcHWOfzOxaVDPTJHEcS+8ISyKoxl7fHMsvLDmnDDqqRYvBksMqYu3MUh63D5I
         +pKXBi5IEDAbvXcbgjd0E5wGDQ7s4dgTSsoP4MBsJuFyTU9uCzMHddYo7oPtS71SEXvb
         1urqDNJturbphpz/zHl2CmrxHG+FkvQRyCoUa8doAelJpdvu2ZTpuWgJwIl/+0O4BXTj
         Clx3n/FXefZrG2V10jUAD1rORC5iyXowhHau/FSZULowNM0bgw5G3Jb9/do6ISZpeLnk
         PujR9PoFZsOb1hrGYDCKaxvLibUNUomiHHdfKrEHsZno2L3n/Huu0qa4gA6tzX3m4xIm
         ACrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685434784; x=1688026784;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cBHIkC3AgOkCXlgQJMZIKeQ+JgiscMmgY3/0dKa5Q1s=;
        b=Vjym3W2mAstlYiOHv6SgoaAELIG5Kr03a7kEnRwsbuwhO/EtsVhgQF/J587OSxJJAn
         G/3iBz2OTthcO6aL3ZMOwn7ZOr9dKwT9gYKI12RBJCZPJxeF3/VyV9kCObr+P2nDav3/
         1e/kNQr9MKHWFstvXLZpHONmIBHsnbRHEwmKyMHnccxV/FUkLMm4RGcZwSEg5zxWJxFO
         S56xwsC0Q/bm2DM/Tqn17EcHaiKGPhNRDiMhkk1jK6oFV7kNy/8MC7+9CL/1OLNiyTZs
         T9Q2P5f/k3aG9u7Dgx2AvBKVTcdl1flEWO9ErrAs33y7BlEtAMMeUJPuGf9UKQuS71H9
         rjEg==
X-Gm-Message-State: AC+VfDwk2aQbRXH1em/bGxbSjXpXobmygZEgSrsrySCIdSrEsIIssvyf
        lbSdpSQIwafiObjv4Ul14P5LdLzVSnKU/8HTJ2MejfXf
X-Google-Smtp-Source: ACHHUZ78HsHNEuS13vJDwVpxHo29u1WWo2YhOGCfQXHJp/XnGYpDbz9kiMB51pMVdAd6feUPmYrr+6jZTtwH2pd77/4=
X-Received: by 2002:ac8:5e11:0:b0:3f6:b017:6289 with SMTP id
 h17-20020ac85e11000000b003f6b0176289mr1212887qtx.10.1685434783778; Tue, 30
 May 2023 01:19:43 -0700 (PDT)
MIME-Version: 1.0
References: <20230426041124.69544-1-tz.stoyanov@gmail.com> <20230426041124.69544-4-tz.stoyanov@gmail.com>
 <20230529080552.2dbfdc9f@rorschach.local.home>
In-Reply-To: <20230529080552.2dbfdc9f@rorschach.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 30 May 2023 11:19:27 +0300
Message-ID: <CAPpZLN5k2HeZXpsm8U44Jm=VpWkcP5MP=v=6tP_UZ8dV22388g@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] libtracefs: Unit test for tracefs_instance_reset()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, May 29, 2023 at 3:05=E2=80=AFPM Steven Rostedt <rostedt@goodmis.org=
> wrote:
>
> On Wed, 26 Apr 2023 07:11:24 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > +static void test_instance_reset(void)
> > +{
> > +     struct tracefs_instance *instance =3D NULL;
> > +     const char *name =3D get_rand_str();
> > +
> > +     CU_TEST(tracefs_instance_exists(name) =3D=3D false);
> > +     instance =3D tracefs_instance_create(name);
> > +     CU_TEST(instance !=3D NULL);
> > +
> > +     CU_TEST(test_instance_check_default_state(instance) =3D=3D true);
> > +
> > +     CU_TEST(tracefs_tracer_set(instance, TRACEFS_TRACER_HWLAT) =3D=3D=
 0);
> > +     CU_TEST(tracefs_event_enable(instance, "bridge", "fdb_delete") =
=3D=3D 0);
>
> Was there a reason why you picked HWLAT tracer and the fdb_delete trace
> event? Neither exist in my test machine setup, so this test
> automatically fails.
>

Hi Steve,
The only reason to choose them is not to generate many events during
the test, as the test checks the ftrace configuration and not the
generated events. I didn't realize that the tracer and events may not
exist in the system. I noticed your commit, thanks for fixing that!

> -- Steve
>
>
> > +     CU_TEST(tracefs_instance_file_write(instance, "set_ftrace_pid", "=
5") > 0);
> > +     CU_TEST(tracefs_instance_file_write(instance, "trace_clock", "glo=
bal") > 0);
> > +     CU_TEST(tracefs_instance_file_write(instance, "set_event_pid", "5=
") > 0);
> > +     CU_TEST(tracefs_instance_file_write(instance, "set_ftrace_filter"=
,
> > +                                                   "schedule:stacktrac=
e") > 0);
> > +     CU_TEST(tracefs_instance_file_write(instance, "set_ftrace_notrace=
",
> > +                                                   "schedule:stacktrac=
e") > 0);
> > +     CU_TEST(tracefs_instance_file_write(instance, "tracing_cpumask", =
"0f") > 0);
> > +     CU_TEST(tracefs_instance_file_write(instance, "events/syscalls/sy=
s_exit_read/trigger",
> > +                                                   "enable_event:kmem:=
kmalloc:1") > 0);
> > +     CU_TEST(tracefs_instance_file_write(instance, "events/bridge/fdb_=
delete/filter",
> > +                                                   "common_pid =3D=3D =
5") > 0);
> > +
> > +     CU_TEST(test_instance_check_default_state(instance) =3D=3D false)=
;
> > +
> > +     tracefs_instance_reset(instance);
> > +     CU_TEST(test_instance_check_default_state(instance) =3D=3D true);
> > +
> > +     CU_TEST(tracefs_instance_destroy(instance) =3D=3D 0);
> > +     tracefs_instance_free(instance);
> > +}
> > +



--=20
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
