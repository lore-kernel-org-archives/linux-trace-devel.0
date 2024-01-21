Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39831381A4
	for <linux-trace-devel@vger.kernel.org>; Sun, 21 Jan 2024 17:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705856938; cv=none; b=r4c7s18KdFOIkVhjCsx2nCPHrnBI19ut1R4inPknTI9kBWCEiZAkpuxg6GZ+aEglIyE1xtkODc6joI/DoRsk+1SJ/Uzsn1S97BD3PAql9DUrlk4iTVU21L0EDIW48/P36au9vBkxoEXkjagodvSSUXwpDfYx8Ec8ra94By/RJQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705856938; c=relaxed/simple;
	bh=qQlGSH5vN5H7frxuI/q/nyATFTbaAu8v3EQzhGW0eO0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=isso1qTC4av69DXxNN5MhoSZCM794x9F3VHSI3YHIKsTnBiCl+54QGRlTqJlZRMjZPai2I23a+kFt/8R8aA+vigri2CYIcxAcRA8TnAW9gp04cYMYbtF/KPALIORC5m88xCp6u1fw5hO2ypXZgF9Wfl30w5V5F7mrce9Enaf36I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c2U9M0bX; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c2U9M0bX"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-50e9e5c97e1so2809351e87.0
        for <linux-trace-devel@vger.kernel.org>; Sun, 21 Jan 2024 09:08:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705856934; x=1706461734; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WXNdxETDTuAFtiQm+inf6C/5IKEB2uyzhmqIhtyZ6wo=;
        b=c2U9M0bXEfrNmBwDNkWoZuhqJnRq8h4aTM4zXgBDRzPF64JuB2hSWHlFG8QsGaieh0
         Zvc0/6ZS/iRpGNYWi4dUGdxTlEGfVR05cslzOjpSrR20MMOp2FjdLgy/2NLMtApqubaG
         AlS9Xh3u5KrVbpecH56lEsB1OWcw/GyXs7LtMRogPrhd/FFzKEtYUwkOHapsgCvwp7+g
         GVGXaaTz+qZFVqTkDaHgp0dV1HU11vqv3IOSuvYHyLIxTELpFBIHI+02JMVlT6kVSW3L
         IqHA3IyJ4ow9vSY4/v04GfhoYRlKj1VBQ+fDXyR+deRZTs7efixYEoS9WpPGETMW6/Ue
         cOjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705856934; x=1706461734;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WXNdxETDTuAFtiQm+inf6C/5IKEB2uyzhmqIhtyZ6wo=;
        b=VM8FyNhyW3vgQmdy7ogzUfeaNeDyiHGjT5L7VQSD7gJ++yQpvxuOO8EH3qIMVHyW5B
         K+qWVG6msaYZBpKPJ3xMMDdeK316genZduvCRR/wKX9j0CeRfd6qANpkM6XLHmyXr8GU
         UAHC88q8tTVaJmFoipJYlyAGQPWFYDpZzYFopLoebXUhjuPjVeNk/WTtDbYc6EPSoix9
         TsvDOOq4+LtZojNh4SaytCBRaLx74BqPTpxzvC+iAwFhXPuf2nzyGHKAhpdujdKYadpX
         zKFknvauZVmclqOgJ18367GO0nF1iap5jsTPAlVNnlV8Svvr0RD9lEggYT5pnJIzFSOb
         L34g==
X-Gm-Message-State: AOJu0YyL/oHE0UitpWWjxua/m7JxkdGV6hcjWazXUW5ctQ22s4frhSPg
	s4+aa5XRv9OkVvup2esSzPbmPgwAMDSjtVxVgkrrDhuNMexBFli6QqvP+I7E
X-Google-Smtp-Source: AGHT+IGkVcBCuPB/EnbyobXxthwwX9zrSwbWvHn1/TzyVHWBLSMEg8fvqPfkOLxzXUueK1Wmhn1qdQ==
X-Received: by 2002:ac2:5297:0:b0:50e:aa74:5ff9 with SMTP id q23-20020ac25297000000b0050eaa745ff9mr993682lfm.15.1705856933906;
        Sun, 21 Jan 2024 09:08:53 -0800 (PST)
Received: from [192.168.0.107] (83-228-63-4.ip.btc-net.bg. [83.228.63.4])
        by smtp.gmail.com with ESMTPSA id y11-20020a170906524b00b00a233515c39esm12466582ejm.67.2024.01.21.09.08.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Jan 2024 09:08:53 -0800 (PST)
Message-ID: <81d345f5-5352-1a2f-e18e-72ad0d9a6788@gmail.com>
Date: Sun, 21 Jan 2024 19:08:52 +0200
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 00/34] Fix kernelshark issues introduced by the migration
 to Qt6
Content-Language: en-US
To: Benjamin ROBIN <dev@benjarobin.fr>
Cc: linux-trace-devel@vger.kernel.org
References: <20240114171723.14092-1-dev@benjarobin.fr>
From: Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20240114171723.14092-1-dev@benjarobin.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Benjamin,

I am applying most of the patches from your patch-set. I have some minor 
comments about few of the changes that I will make in the individual 
patches.

Once again, thanks a lot for helping us to improve kernelshark!

Cheers,
Yordan

On 1/14/24 19:16, Benjamin ROBIN wrote:
> There were 3 majors issues:
>   - A segfault when loading a trace file (patch 0001)
>   - The trace table height was very small (patch 0032)
>   - The trace table columns width were reducing when clicking
>     Marker A or B (patch 0032)
> 
> Also fix most of the warnings reported by Clang-Tidy and Clazy, and by
> gcc with -Wextra.
> 
> 
> Benjamin ROBIN (34):
>    kernelshark: Fix modelReset() signaling, rename update to updateGeom
>    kernelshark: Add .gitignore
>    kernelshark: Remove function param when not used, whenever possible
>    kernelshark: Do not create a temporary container for looping over QMap
>    kernelshark: Prevent potential detach of QMap container
>    kernelshark: Fix used after free of QByteArray raw data
>    kernelshark: Fix potential memory leak in KsGLWidget
>    kernelshark: Use lambda parameter instead of captured local variable
>    kernelshark: Keep overridden method protected instead of public
>    kernelshark: Use sliced() or first() instead of mid/right/left()
>    kernelshark: Prevent potential divide by zero in Shape::center()
>    kernelshark: Fix potential access to uninitialized variable
>    kernelshark: Remove unused locals variables
>    kernelshark: Fix range-loop-reference Clazy warning
>    kernelshark: Fix moving a temp object prevents copy elision warning
>    kernelshark: Add receiver object to connect() call
>    kernelshark: Return by reference the list of header in KsModels
>    kernelshark: Fix detaching-temporary Clazy warning
>    kernelshark: Fix qfileinfo-exists Clazy warning
>    kernelshark: Fix potential memory leaks in libkshark-configio
>    kernelshark: Fix potential access to uninitialized variable
>    kernelshark: Fix potential double free of histo->map, histo->bin_count
>    kernelshark: Fix 'const' type qualifier on return type has no effect
>    kernelshark: Fix potential memory leaks in libkshark-tepdata
>    kernelshark: Fix typo in comment of KsGLWidget::resizeGL()
>    kernelshark: Remove unused KsDataWidget::wipPtr() and broken function
>    kernelshark: In KsTimeOffsetDialog() constructor use parent param
>    kernelshark: Fixed loop counter incremented suspiciously twice
>    kernelshark: Fix tepdata_dump_entry() for event_id = KS_EVENT_OVERFLOW
>    kernelshark: Use static_cast instead of C cast in KsMainWindow
>    kernelshark: Fix comparison of integers of different signs warnings
>    kernelshark: Fix KsTableView columns width, and KsTraceViewer size
>    kernelshark: Allow to reduce a bit more the graph height
>    kernelshark: Cleanup of KsDualMarker methods
> 
>   .gitignore                     | 15 ++++++
>   examples/configio.c            |  3 +-
>   examples/datafilter.c          | 15 +++---
>   examples/datahisto.c           |  2 +-
>   src/KsAdvFilteringDialog.cpp   | 24 ++++------
>   src/KsAdvFilteringDialog.hpp   |  2 +-
>   src/KsDualMarker.hpp           | 10 +---
>   src/KsGLWidget.cpp             | 48 +++++++++----------
>   src/KsGLWidget.hpp             | 43 ++++++++---------
>   src/KsMainWindow.cpp           |  8 ++--
>   src/KsModels.hpp               | 11 +++--
>   src/KsPlotTools.cpp            | 14 +++---
>   src/KsPlotTools.hpp            |  2 +-
>   src/KsSession.cpp              |  4 +-
>   src/KsTraceGraph.cpp           |  7 ++-
>   src/KsTraceViewer.cpp          | 71 ++++++++--------------------
>   src/KsTraceViewer.hpp          | 11 +++--
>   src/KsUtils.cpp                |  9 ++--
>   src/KsUtils.hpp                |  4 +-
>   src/KsWidgetsLib.cpp           |  2 +-
>   src/KsWidgetsLib.hpp           | 15 ++----
>   src/libkshark-collection.c     | 14 +++---
>   src/libkshark-configio.c       | 84 +++++++++++++++++++---------------
>   src/libkshark-hash.c           |  5 +-
>   src/libkshark-model.c          | 19 ++++----
>   src/libkshark-tepdata.c        | 31 ++++++++-----
>   src/libkshark.c                | 17 +++----
>   src/libkshark.h                | 20 ++++----
>   src/plugins/KVMComboDialog.cpp |  7 +--
>   src/plugins/sched_events.c     |  2 +-
>   tests/test-input.c             |  4 +-
>   tests/test-input_ctrl.c        |  4 +-
>   32 files changed, 257 insertions(+), 270 deletions(-)
>   create mode 100644 .gitignore
> 
> --
> 2.43.0
> 
