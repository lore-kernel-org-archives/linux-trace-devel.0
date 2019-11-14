Return-Path: <SRS0=uJmw=ZG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9AD7C432C3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Nov 2019 23:31:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B91E20724
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Nov 2019 23:31:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o7cYWT2N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbfKNXbb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Nov 2019 18:31:31 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:39920 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726767AbfKNXbb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Nov 2019 18:31:31 -0500
Received: by mail-qk1-f195.google.com with SMTP id 15so6631453qkh.6;
        Thu, 14 Nov 2019 15:31:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:user-agent:in-reply-to:references:mime-version
         :content-transfer-encoding:subject:to:cc:message-id;
        bh=Qge9CCV+EX+KklZtFlR08GP7ynLSZVKpctR9wLJZkrk=;
        b=o7cYWT2NAVBTODktXqN3bA5MNTX9oujvZ+1oQbd/jgb4c0pWMubNMRnizhS18w0N3F
         RTUuhtyo182IjhuqjWUbPSJQnRXUaTyRyOChyC34m8VlymqsqQByM78aaTsm8WQmXRu/
         3M5KHVNYv+4u2JW2r0k7LBLfK/PVkO7+B4lzyJC+ATHFVDY1W3MBOptKDktGXGf4sOaM
         lYDtkrKg8J3hOHseidITWb6yw6RRteCZc+ucs8iLzUCLp+eStFbmD8vZFwRcq5HE7qpz
         VTAqNSHMzz0hk1XkiPJxSKmUfpH24wxk6ZEfQRO9SzM9Ngq1h6f5f73KXWXcEe1VptSu
         wluQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:user-agent:in-reply-to:references
         :mime-version:content-transfer-encoding:subject:to:cc:message-id;
        bh=Qge9CCV+EX+KklZtFlR08GP7ynLSZVKpctR9wLJZkrk=;
        b=FCHrVm2oacByDz/oToRsvweLGI5P7wpQntFj86HbDx5yoC6Dj5YcqLDYFU44rBxKz5
         I2laOUS28/eBSx9ssUaq5DbdQKuq66qgDHbEakJQpwraLO+4PFTC2b/NmgtFfNkMXyyt
         mNP2VSTshigPUrOx9n4fHwHiuEJOLkKWm1JkX660FUc1uW1Fbl9J81CrN9jLOs1TLT8Q
         K9gY3i7TSmzGyxf3oeKpuHaUwDzyvLNpXsu0lD8lSYPWvbbeHmHXjZDiLiLR33qp1sZd
         H0r7nL+EBVbipihyDRH4bbCT37IPmPci0yFJKwnCKYTt2c48CQ9A/fK1WZuBScczDNI4
         peuQ==
X-Gm-Message-State: APjAAAWiTfw1EsSGypKx5RUGBIZMxiLKLgGYbaj/kCzs9VGdbhrsS+HX
        aC3jdQgTtT40it68OIcvZtQF4/1o
X-Google-Smtp-Source: APXvYqyvMYZ8hJ6uDmNcs55NE/gS6PLnVHtMH2DMhGL/GQeqxUNy/0vu4dHELi5ALZixu8fUbnGFxw==
X-Received: by 2002:ae9:e114:: with SMTP id g20mr9327083qkm.13.1573774290102;
        Thu, 14 Nov 2019 15:31:30 -0800 (PST)
Received: from [192.168.86.249] ([179.97.35.50])
        by smtp.gmail.com with ESMTPSA id x1sm3818039qtf.81.2019.11.14.15.31.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Nov 2019 15:31:29 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Date:   Thu, 14 Nov 2019 20:30:30 -0300
User-Agent: K-9 Mail for Android
In-Reply-To: <20191114174022.62c8259e@gandalf.local.home>
References: <20191114133719.309-1-sudipm.mukherjee@gmail.com> <20191114174022.62c8259e@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] libtraceevent: fix header installation
To:     Steven Rostedt <rostedt@goodmis.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
CC:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Message-ID: <76775DFB-79CB-4B85-86CE-EB9406976E9D@kernel.org>
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On November 14, 2019 7:40:22 PM GMT-03:00, Steven Rostedt <rostedt@goodmis=
=2Eorg> wrote:
>
>Arnaldo,
>
>Can you take this?

Sure

>
>Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis=2Eorg>
>
>-- Steve
>
>
>On Thu, 14 Nov 2019 13:37:19 +0000
>Sudip Mukherjee <sudipm=2Emukherjee@gmail=2Ecom> wrote:
>
>> When we passed some location in DESTDIR, install_headers called
>> do_install with DESTDIR as part of the second argument=2E But
>do_install
>> is again using '$(DESTDIR_SQ)$2', so as a result the headers were
>> installed in a location $DESTDIR/$DESTDIR=2E In my testing I passed
>> DESTDIR=3D/home/sudip/test and the headers were installed in:
>> /home/sudip/test/home/sudip/test/usr/include/traceevent=2E
>> Lets remove DESTDIR from the second argument of do_install so that
>the
>> headers are installed in the correct location=2E
>>=20
>> Signed-off-by: Sudip Mukherjee <sudipm=2Emukherjee@gmail=2Ecom>
>> ---
>>=20
>> Hi Steve,
>> sent this earlier as an attachment to an email thread, not sure if
>you
>> saw it, so sending it now properly=2E
>> The other problem with the pkgconfig, I guess we can live with that
>for
>> now as that folder is given by pc_path=2E
>>=20
>>  tools/lib/traceevent/Makefile | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>=20
>> diff --git a/tools/lib/traceevent/Makefile
>b/tools/lib/traceevent/Makefile
>> index 5315f3787f8d=2E=2Ecbb429f55062 100644
>> --- a/tools/lib/traceevent/Makefile
>> +++ b/tools/lib/traceevent/Makefile
>> @@ -232,10 +232,10 @@ install_pkgconfig:
>> =20
>>  install_headers:
>>  	$(call QUIET_INSTALL, headers) \
>> -		$(call do_install,event-parse=2Eh,$(DESTDIR)$(includedir_SQ),644); \
>> -		$(call do_install,event-utils=2Eh,$(DESTDIR)$(includedir_SQ),644); \
>> -		$(call do_install,trace-seq=2Eh,$(DESTDIR)$(includedir_SQ),644); \
>> -		$(call do_install,kbuffer=2Eh,$(DESTDIR)$(includedir_SQ),644)
>> +		$(call do_install,event-parse=2Eh,$(includedir_SQ),644); \
>> +		$(call do_install,event-utils=2Eh,$(includedir_SQ),644); \
>> +		$(call do_install,trace-seq=2Eh,$(includedir_SQ),644); \
>> +		$(call do_install,kbuffer=2Eh,$(includedir_SQ),644)
>> =20
>>  install: install_lib
>> =20

