Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17604C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 11 May 2022 18:33:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346332AbiEKSdy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 11 May 2022 14:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346335AbiEKSdx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 11 May 2022 14:33:53 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F12851B57A0
        for <linux-trace-devel@vger.kernel.org>; Wed, 11 May 2022 11:33:51 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id m20so5730507ejj.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 11 May 2022 11:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-transfer-encoding:user-agent:mime-version;
        bh=x6mqLMyemfZg0yhCGkKFdMDvfqt2Un/fcjHTCRHmuNo=;
        b=bYn7MvJRFUinkOG9I5Zqyz/TWRTsFMiZgTIGmmmOfxTKTmvof0bqKWFSsW13gxexBl
         qlfZCZ9ebyZvBSj4xSd2Hzmi8RIBrozkWiPmXY09WLn6ynhdOKrtLmzPk2a1dqey+Jmr
         mctgqXMqxHfUeSnqeZUPGej+hXFPhe7UBb7Qk9QOCysT6tC6bsP1lrYDeeMM7lY2aXJN
         5lMMQCJWhXg/1q/GiIqUh7JoyaaNlkytv+Se+acH/YfNE7IlIipigDjSgXerHHo9LDTf
         pesaScFyZ1S82KSzhAZC8460gyLZGoMWo6wR5F6goEgaNiGnN/TkJ4IdnOfasPdbT4tO
         K3Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:content-transfer-encoding:user-agent:mime-version;
        bh=x6mqLMyemfZg0yhCGkKFdMDvfqt2Un/fcjHTCRHmuNo=;
        b=ZoiGsWToMC5hW8DTCdYepiIlEluxEBXM5HjDBRdmklA5GVOaWKFDolWvJ+UYHHqOn9
         yp58jg7h8M6bKOwL7TyLtAETBABX69ro15ANncwt3RmBKIQgWh/PQOQggUtoSgGHqDBq
         eBvvVsELufimQ6E3QMPtg6pSqxsnlYUEa4dHoq3AzxEIDgt1vAnKEKEI3vC0vxKhB2ZK
         ij0M/qwBT25cyqt2+yeZiwZ3M3+lfIqbjYqSzX341nxN6qNi9FyFPkhTUwprBQpAVzhI
         Mw0CL5BjwWmwpfNZyTCjl7Rimg7jkJ+DRcQgaerO3WX/CC2Y1B5eYSGkSrz5bSZXBSVS
         F8UA==
X-Gm-Message-State: AOAM5315E3cvj69Cs8SNNjr5xtCJMGLswdjml6DlZybYqtYkSMZrLDTs
        5hLPsH1668pfbr2l6jjoSdDotkokoAA=
X-Google-Smtp-Source: ABdhPJzKbxbSuWHRvHDsHr2yruaigDDOHH0w3B5ntMMXm3HAlA1okT1yRCQebWCqgz/6VBJdwKyoiQ==
X-Received: by 2002:a17:906:9748:b0:6fa:8c68:af0e with SMTP id o8-20020a170906974800b006fa8c68af0emr13640902ejy.153.1652294030465;
        Wed, 11 May 2022 11:33:50 -0700 (PDT)
Received: from [192.168.3.2] (p5dd1ed70.dip0.t-ipconnect.de. [93.209.237.112])
        by smtp.googlemail.com with ESMTPSA id c2-20020a170906528200b006f3ef214e15sm1229625ejm.123.2022.05.11.11.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 11:33:49 -0700 (PDT)
Message-ID: <fbb8049e2a9fcce07110d5d97f08458d27c977b4.camel@gmail.com>
Subject: Re: how to register an event handler for the instance
From:   christopher lee <christopher.lee.eu@gmail.com>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Date:   Wed, 11 May 2022 20:33:48 +0200
In-Reply-To: <CAPpZLN4A8tes3tnzDqLFBT7S2SvBixFwDW7GkYbSPeA+3e1yCQ@mail.gmail.com>
References: <93fd065420c6a04141b5e8ba9c89dae1e7c9b6a0.camel@gmail.com>
         <CAPpZLN4A8tes3tnzDqLFBT7S2SvBixFwDW7GkYbSPeA+3e1yCQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.0-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, 2022-05-07 at 08:02 +0300, Tzvetomir Stoyanov wrote:
> On Fri, May 6, 2022 at 7:18 PM christopher lee
> <christopher.lee.eu@gmail.com> wrote:
> >=20
> > Hi all,
> >=20
> > I use libtraceevent in my trace tool to parse the event log. Now I
> > allocated an instance, but no idea how to use
> > tep_register_event_handler() to register a handler for the
> > instance. Is
> > it possilbe to register handler for the event in the instance?
> >=20
>=20
> Hi Chrit,
> All trace events are the same across all trace instances, thus the
> handler registered with tep_register_event_handler() handles events
> from all instances with a given id. That's why there are no
> "instance"
> oriented APIs in that library. I would suggest looking at the tracefs
> library, which is instance aware. It can be used to allocate trace
> instances and read events from a given instance.
>=20
> https://trace-cmd.org/Documentation/libtracefs/
>=20


Hi Tzvetomir Stoyanov,

Thanks,  instance event handlers work now, but I'm confused with these
codes, do I have to read trace_pipe_raw? I found that if I didn't read
this file, the handler would not be able to get trace information.
Becuase if I read this file, and also call tep_print_event() will
consume lots of CPU resoruce. how can I parse the trace event info
without reading this file?
=20

        for (i =3D 0; ; i++) {                                         =20
                char *raw_buf;                                       =20
                char *cpu;                                           =20
                                                                           =
                        =20
                ret =3D asprintf(&cpu, "%s/cpu%d", per_cpu, i);        =20
                if (ret < 0)                                         =20
                        pdie("Could not allocate memory for cpu buffer
%d name", i);               =20
                                                                           =
                        =20
                ret =3D stat(cpu, &st);                                =20
                if (ret < 0 || !S_ISDIR(st.st_mode)) {               =20
                        free(cpu);                                   =20
                        goto start;                                  =20
                }                                                    =20
                                                                           =
                        =20
                ret =3D asprintf(&raw_buf, "%s/trace_pipe_raw", cpu);  =20
                if (ret < 0)                                         =20
                        pdie("Could not allocate memory for cpu %d raw
buffer name", i);           =20
                                                                           =
                        =20
                read_raw_buffer(i, raw_buf);                         =20
                free(raw_buf);                                       =20
                free(cpu);                                           =20
        }=20

Best regards,
Christ

>=20
