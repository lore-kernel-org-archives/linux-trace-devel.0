Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A8D12B75
	for <linux-trace-devel@vger.kernel.org>; Sat, 20 Jan 2024 20:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705783879; cv=none; b=D4yfqJ7K0PCPXEfnXL4w/1kY7YU//hqXmAmyGwt2WRWd37UTQrd7xr76LikloM9B2LHpcAi71l9dC/n5z5xOXKmDF6Y6QJHDVzncoyNZXhIUKNGd4tV0frazyHXgFKutA5+VPwxGz8PXhkoxUvOCICM4KmpCllRdYGwrhKIaVaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705783879; c=relaxed/simple;
	bh=DSWanOeReofmn064ISBO7/un19rms+RhStzml7oO/YQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=EP/9YaOnDBTPuvFz4Pk3uElAtY0TyQemklzZ2+DPvoa3SGgJ0nXHl9IuYrxx1WSo4DrDO/81tVzwh1DkVzvKtIJchEWaobCx1JP9qeaJINmRBOKP0QQ9o2X1I/kJWFxrbh96aWw0pfMlD0Lg0tLvT2uL+ooywxiZQtxB97REw0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=auDeBW8o; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="auDeBW8o"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a2cea0563cbso287341466b.3
        for <linux-trace-devel@vger.kernel.org>; Sat, 20 Jan 2024 12:51:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705783876; x=1706388676; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=B0bKN+t/oL8u/gZGaME7ZXCK/xfqeR9/Ixhmd1zG3hQ=;
        b=auDeBW8oxl8ATGQ7aUacf4lF9WYmkPRAyFRoPfxeie42FmCnAuVbNTLojd5AWb4uN+
         dF/xLiyutz4Pwto2PMR3tjIlmB0/ZZ2nmG+A3TEen6dFcSODJFnNtlqp2HzF5WLvpVyu
         L9ca52vRzJW9cu6VE1J42b6gV/8e58odkz/cu8IIWO6556IzTzrcXNmTwQ2TQcxA2LTN
         lOoxlQn/Tf8MazmJi9If86r6lyWx2d5seL9SihAQJGCwyyyyqu/5M2k0eGxocWyqgNDt
         JmZ77ICOVajtemJI7sDhyWaH3uMNhcNqwCTtODYxM910ZdBwCb3YMabltgKyMjtsBgJ/
         jytg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705783876; x=1706388676;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B0bKN+t/oL8u/gZGaME7ZXCK/xfqeR9/Ixhmd1zG3hQ=;
        b=V2slDpFoOdewHyUE43WcAeN5hS+tBroD9uZSpJxT6IP5greFQUfhVne6pYdyAjw/1M
         kNR7pkSxHuaIlQvsljuaxShw+I/uEmClt08oPSuAj+ydxc2fhGxhLxurnTg2kXnMTMau
         HG4Im06EtEQ3SpY1Mtux2PD7oSI++o91yisInYTvnyzT6MWikJ4gXgr2ig4A4JXBUhNB
         rywf3LIpHVP6ljeNyiWKjpXCAX3XJ4SEcRCNWC9EoiJi6rN+LYbMByLES7b3tc8AyggD
         czEaPypNrbg/U34v+nR0Pxnx6STbu1pGiHVbrc5yS2J2xmmPyh/aQHfXPQDdvCa32Aad
         K3rA==
X-Gm-Message-State: AOJu0YxxhqUGnrHPWTKO44K3hDWi9a7v1DIRQBqxvQThyCjWymi6RP5/
	tSOSrnCbKYQQJi2+bJuhqxv8Ui2C+mYURwDb1QDHulL/3KG1fkz/W6qnOjW+jrSKXnP7OA5Uw4s
	BVRc960gAnH9G2qAqbcoYf6EXgm4=
X-Google-Smtp-Source: AGHT+IEeb+iI4B/Pdp6zmEY/kQ+qKhjHaC1UVascTYqhrHc+8ffctyoakdJYHu1/v8FMIQwdJWc1aeTbhw0QiAFwXNU=
X-Received: by 2002:a17:906:745:b0:a2e:9835:d2e6 with SMTP id
 z5-20020a170906074500b00a2e9835d2e6mr1020979ejb.144.1705783875763; Sat, 20
 Jan 2024 12:51:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date: Sat, 20 Jan 2024 20:50:39 +0000
Message-ID: <CADVatmNXhhn6xhL-=rYqDaHqp4Ct+_i5N42KpeJnnxwoH1Ee+A@mail.gmail.com>
Subject: kernel-shark fails to display
To: Steven Rostedt <rostedt@goodmis.org>, Yordan Karadzhov <y.karadz@gmail.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi,

I am seeing a problem with the latest version v2.3.0
Steps to reproduce:
1. start kernel-shark
2. Go to Record in Tools menu
3. Select Events: All
4. Select "Display output"
5. Click on Apply
6. Click on Capture

It fails with:
kernelshark: ./src/libkshark-model.c:249: ksmodel_set_upper_edge:
Assertion `row != BSEARCH_ALL_GREATER' failed.
Aborted


-- 
Regards
Sudip
