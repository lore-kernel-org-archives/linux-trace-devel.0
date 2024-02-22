Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDA42C695
	for <linux-trace-devel@vger.kernel.org>; Thu, 22 Feb 2024 08:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708592271; cv=none; b=tw6jC3iVRdtcNaI4B5ZRdes/ba01zO0ynCytHpawh1vLHBrw/roCeOsE01zvtmHyGfLjCh/cQWCwYocZavdqfDQzlFYMdKIwo7bZF5ynGjfZqG6mja+oV0Ivz0jKdov0SC/eNJeZyyKsUPjy0TtNLniWw6bpL1LwgsNVIYnyPlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708592271; c=relaxed/simple;
	bh=cGDNtau/Kp9yCRzrgIdQY93bk2lqd5KbWcMjCd+5/xw=;
	h=Mime-Version:Content-Type:Date:Cc:Subject:From:To:Message-Id:
	 References:In-Reply-To; b=gbzQHlYe3hxJGZpeboorX0TlTdIuLrZbrHwv1jwZMoEB904VkPSeWYdI+gi2nNZNOz6BkM3erHgCM8r7D16qR8Kb4Y3l/0gK4HLKQCF6nLTuLbLGyR6zcUrzI4sT4asScFpGM9HHRUE/4N71qc0F81OZ8SYULYwSJ80NEu2EnFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NDrhyQUF; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NDrhyQUF"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a3e85a76fa8so455497666b.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Feb 2024 00:57:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708592268; x=1709197068; darn=vger.kernel.org;
        h=in-reply-to:references:message-id:to:from:subject:cc:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pqa6sPCKoV/3qSkfygzOD1cOIqXnFtE5yer3WxUTyEI=;
        b=NDrhyQUF8KbqyC+yixdL3fH4Y3qEPHU68WqRjeT6FywM5N05T0C+tutRmobY2MdX8o
         srO/+Rh+x9TKsrS/FvJexgo5t3VSOZHmbqFdOk5jSYFyjwg71KongN3yt+AGsa2jRzq4
         QEpaEHMkS86KY4OeyEQiA3SiKfM7qVIvobmglXUpsdfqwvHsiSabub8KgAUIBzhXwysq
         IUFOvqjOSKkAGHHyGdoqJ2eFL67iKscyzguDFxzAAvOricDE6reecrhRvs/tCPY+GMkF
         qaxIzx8drpSZHBketf7nSrPVL9s9XH6yJL6Fv/T/tmpU6Ph9/eo/DVtJETnQihEk8wqU
         6XIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708592268; x=1709197068;
        h=in-reply-to:references:message-id:to:from:subject:cc:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Pqa6sPCKoV/3qSkfygzOD1cOIqXnFtE5yer3WxUTyEI=;
        b=rlhqXPGeZckiMDdYBN8Okg5O/Attp7jglyRwwwVJ/b3VvpU379hDBxO3L/+d5uuLY2
         tqS+HoDM6ibJSCCDTj/q9P5vD/GsRIEfvS2Tld1LjSnUxdCMPtO/kIk53kYeuQqGDhwV
         v7OYi4aLOlvmARJe3VglPuMwSCSjVUCXhwuXOuSuIE0xj9qcYvv5s62CdRH6EcXje29k
         vLEi5vFQ6zoL4cHRqgnY5W1CyQ6YyNWYDqEkDnvqG5oBxfjMwugNa+6kJmRjITnD/ZRF
         a3SszVe8aLWeqAwBxp2+oIF0bCgxdMapFg/cWYLsErYikgT7HCqvdBPm5pXd0i/gFE0V
         R1Mw==
X-Gm-Message-State: AOJu0Yxr1unrRjgNDpfz9bnOROoWe87uerJqS3yMu2Y8LQrbyX7rfD5L
	jPexHMeXbvUt1S/oc05DcDHFS2JcKUxI4I2fcp33vru4yI94mAoivvJ8AWR0
X-Google-Smtp-Source: AGHT+IHrZ0QIDsoP78l09Ipplbl4qp5AacpqGNzmgjYC1PSEhPe55lDHoMVZ8QkEajLF5X5/HtANwg==
X-Received: by 2002:a17:906:34c3:b0:a3e:b407:65ab with SMTP id h3-20020a17090634c300b00a3eb40765abmr6565182ejb.50.1708592268201;
        Thu, 22 Feb 2024 00:57:48 -0800 (PST)
Received: from localhost (81-234-98-96-no2390.tbcn.telia.com. [81.234.98.96])
        by smtp.gmail.com with ESMTPSA id gc24-20020a170906c8d800b00a3e4d2d99adsm4834867ejb.219.2024.02.22.00.57.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Feb 2024 00:57:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 22 Feb 2024 09:57:46 +0100
Cc: <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 1/3] utest/tracefs-utest: add missing include
From: "Miko Larsson" <mikoxyzzz@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>, "Miko Larsson via B4 Relay"
 <devnull+mikoxyzzz.gmail.com@kernel.org>
Message-Id: <CZBHEKUYMA8T.3NF5EMMWQFUWV@sakura.myxoz.lan>
X-Mailer: aerc 0.15.2
References: <20240215-utest-fixes-v1-0-24678d859de2@gmail.com>
 <20240215-utest-fixes-v1-1-24678d859de2@gmail.com>
 <20240221184803.3fcc5455@gandalf.local.home>
In-Reply-To: <20240221184803.3fcc5455@gandalf.local.home>

On Thu Feb 22, 2024 at 12:48 AM CET, Steven Rostedt wrote:
> What exactly is this fixing. I tried building the tests with clang 16 and=
 I
> don't get any errors. Please show the error that you have without this
> change.
Hm, yeah, could be that this occurs with clang >16, not sure though.

Following is the error I get with clang 18 without this patch applied:
FAILED: utest/trace-utest.p/tracefs-utest.c.o=20
clang -Iutest/trace-utest.p -Iutest -I../utest -Iinclude -I../include -I/us=
r/include/traceevent -flto=3Dthin -fdiagnostics-color=3Dalways -D_FILE_OFFS=
ET_BITS=3D64 -Wall -Winvalid-pch -std=3Dgnu99 -D_GNU_SOURCE -Wformat -Werro=
r=3Dformat-security -ftrivial-auto-var-init=3Dzero -fstack-clash-protection=
 -fsanitize=3Dsigned-integer-overflow,integer-divide-by-zero -fsanitize-tra=
p=3Dsigned-integer-overflow,integer-divide-by-zero -fno-sanitize-recover -f=
lto=3Dthin -O2 -ffile-prefix-map=3D/builddir/libtracefs-1.8.0=3D. -g2 -pthr=
ead -MD -MQ utest/trace-utest.p/tracefs-utest.c.o -MF utest/trace-utest.p/t=
racefs-utest.c.o.d -o utest/trace-utest.p/tracefs-utest.c.o -c ../utest/tra=
cefs-utest.c
../utest/tracefs-utest.c:2494:12: error: use of undeclared identifier 'PATH=
_MAX'
 2494 |         char self[PATH_MAX] =3D { 0 };
      |                   ^
../utest/tracefs-utest.c:2850:12: error: use of undeclared identifier 'PATH=
_MAX'
 2850 |         char link[PATH_MAX + 1];
      |                   ^
../utest/tracefs-utest.c:2851:12: error: use of undeclared identifier 'PATH=
_MAX'
 2851 |         char path[PATH_MAX + 1];
      |                   ^
../utest/tracefs-utest.c:2856:17: error: use of undeclared identifier 'PATH=
_MAX'
 2856 |         snprintf(link, PATH_MAX, "/proc/self/fd/%d", fd);
      |                        ^
../utest/tracefs-utest.c:2864:29: error: use of undeclared identifier 'PATH=
_MAX'
 2864 |         ret =3D readlink(link, path, PATH_MAX);
      |                                    ^
../utest/tracefs-utest.c:2866:12: error: use of undeclared identifier 'PATH=
_MAX'
 2866 |         if (ret > PATH_MAX || ret < 0)
      |                   ^
../utest/tracefs-utest.c:2887:12: error: use of undeclared identifier 'PATH=
_MAX'
 2887 |         char path[PATH_MAX + 1];
      |                   ^
../utest/tracefs-utest.c:2896:17: error: use of undeclared identifier 'PATH=
_MAX'
 2896 |         snprintf(path, PATH_MAX, "/proc/self/fdinfo/%d", fd);
      |                        ^
../utest/tracefs-utest.c:3028:12: error: use of undeclared identifier 'PATH=
_MAX'
 3028 |         char file[PATH_MAX];
      |                   ^
../utest/tracefs-utest.c:3043:17: error: use of undeclared identifier 'PATH=
_MAX'
 3043 |         snprintf(file, PATH_MAX, "options/%s", name);
      |                        ^
../utest/tracefs-utest.c:3092:12: error: use of undeclared identifier 'PATH=
_MAX'
 3092 |         char file[PATH_MAX];
      |                   ^
../utest/tracefs-utest.c:3112:18: error: use of undeclared identifier 'PATH=
_MAX'
 3112 |                 snprintf(file, PATH_MAX, "options/%s", name);
      |                                ^
../utest/tracefs-utest.c:3256:12: error: use of undeclared identifier 'PATH=
_MAX'
 3256 |         char file[PATH_MAX];
      |                   ^
../utest/tracefs-utest.c:3460:12: error: use of undeclared identifier 'PATH=
_MAX'
 3460 |         char path[PATH_MAX];
      |                   ^
../utest/tracefs-utest.c:3480:17: error: use of undeclared identifier 'PATH=
_MAX'
 3480 |         char file_from[PATH_MAX];
      |                        ^
../utest/tracefs-utest.c:3481:15: error: use of undeclared identifier 'PATH=
_MAX'
 3481 |         char file_to[PATH_MAX];
      |                      ^
../utest/tracefs-utest.c:3493:17: error: use of undeclared identifier 'PATH=
_MAX'
 3493 |         char file_from[PATH_MAX];
      |                        ^
../utest/tracefs-utest.c:3494:15: error: use of undeclared identifier 'PATH=
_MAX'
 3494 |         char file_to[PATH_MAX];
      |                      ^
18 errors generated.
