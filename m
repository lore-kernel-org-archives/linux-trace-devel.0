Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2915A0E6
	for <linux-trace-devel@vger.kernel.org>; Sun,  3 Mar 2024 15:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709480870; cv=none; b=DoAP5NB/YT+rbCzeI6YNAGJ4ONAJ0OLXBbrdLyf0AGT7hHBv6a2DImu5HSfqE4sGhbfeNXUlfQJtafIDqvIYmf4a7vz7T92BWnbrwngksfMBLd6EB6SARgtjB4huYL0Eg+wsyR4snqmjDIhDq1+EMN3nC1rzFrJc03EcBhQkuGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709480870; c=relaxed/simple;
	bh=616KTN8hp6RIGtkM1j4kn0cvp/BQuL6yVfixa9g3rTA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e/+6v8WXVmWJa8VNqraxzenlOSohWhIV8J90DCaOB5PGgNNK5Nl5r55fk6LxbtcDtEsn8SCG6Ku3XkwkPDQbmJv8dXmrc6507ejYjqAac/Fl4W+y73rVxbDzeexiJQwzcWCNHslXXq25sv23AQma+vpxe+QyyN38qJxlldrgwZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UfEtpiDa; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UfEtpiDa"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a4515f8e13cso51391366b.3
        for <linux-trace-devel@vger.kernel.org>; Sun, 03 Mar 2024 07:47:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709480867; x=1710085667; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FGvvz7yrQEsg/emfPg5ZS1Ywc6pjp39nLE2yVxmo1Oo=;
        b=UfEtpiDamVVFQaR94ISArG3TQgDSxsxyENdeE8nrJ5DddTbspimGP8CA1YsHH7iCYw
         2Qf9whijN5NBr0HlPYhbcfKsY0Pv7GpxQNF3Ci3dKChhf5EIoG5po3ynT0NHLlMjn9fl
         x3rfqENFAKk9Mu6WXCe55/sZDLkc0vPGAKT247hEyvzf9mXPdG1NDf76PHOHO20vTzWb
         if/qi/vjR0EY9Jg/B/DHG1lH8JkNiBuFjzoPLfj8xfQC1skgbq6OBNgUOrUstmLjRkZt
         kbvc/OgQVqGr6aT+DAXvevI6AW7UBfp29sWOINKm9zRkkVauKq6p57EVc3pMcQfzI9S7
         engw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709480867; x=1710085667;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FGvvz7yrQEsg/emfPg5ZS1Ywc6pjp39nLE2yVxmo1Oo=;
        b=OQ3mM3zj7Jni3fo5//2+oPMPl4wXiTCpGLL/MsnWO1YkDdNdKAF2PEZsQmbFrm/Lwd
         MM5YHTSuGun3xgeTjDglWgrzL7ELFgKV4PrXYC2jRxufOZkL4x8HAzlQCD217iMAofpb
         0LcU6pKymSreWN3DaSqtDq11GJY2dS/M4iTbc2W9ep1DJuuNXQuDUE1AZc3cMD/Yzjk7
         KHPFpmYtRXIkqdZMbzGwhLcxN0XEekqZautQE59qyjPGlvqWJbldyY3yMHGHhUGg8cyJ
         JBQ3YQXQ3cmm3bYygVbSnJoDVU6LzF7uH1Zc0pmUTbBh+/sXSvINkeQsb1QDO7R0Tfbg
         BDqA==
X-Gm-Message-State: AOJu0YwEqaAJijPxMVIaxibEKLh2akttvg4HJeGJxh3OFzm0LEh0+I/j
	v/LnMNsPVD/AFZBQPSmPWFPyEeYqF6oj7Yfaml93uNc20MFBZGrqCn9bWfdo
X-Google-Smtp-Source: AGHT+IEPq/5QA7Z7HUBZUHe6KmFQtrE2uqGPB0JU3JISCF+/rRD+WDL1UGmYov2a1CLRwB3Idmgumg==
X-Received: by 2002:a17:906:150f:b0:a45:33fb:35e0 with SMTP id b15-20020a170906150f00b00a4533fb35e0mr679712ejd.73.1709480866513;
        Sun, 03 Mar 2024 07:47:46 -0800 (PST)
Received: from [192.168.0.107] (83-228-63-4.ip.btc-net.bg. [83.228.63.4])
        by smtp.gmail.com with ESMTPSA id u2-20020a1709060b0200b00a45200fe2b5sm626871ejg.224.2024.03.03.07.47.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Mar 2024 07:47:46 -0800 (PST)
Message-ID: <5f716366-4dd0-6b36-f12d-73f3ad4d8c5c@gmail.com>
Date: Sun, 3 Mar 2024 17:47:44 +0200
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
Cc: linux-trace-devel@vger.kernel.org,
 Sudip Mukherjee <sudipm.mukherjee@gmail.com>
References: <20240114171723.14092-1-dev@benjarobin.fr>
 <81d345f5-5352-1a2f-e18e-72ad0d9a6788@gmail.com>
 <vr7u3h23fq5ugctpdm2vqsgk3oj47c6bttf52m2gyic7zcf5fr@35zvpfc7zodq>
From: Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <vr7u3h23fq5ugctpdm2vqsgk3oj47c6bttf52m2gyic7zcf5fr@35zvpfc7zodq>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Benjamin,

We still have one unresolved bug that was reported by Sudip.
I will do my best to get this sorted out and have a new release by the 
end of next week.

Thanks,
Y.

On 3/3/24 11:56, Benjamin ROBIN wrote:
> On Sun, Jan 21, 2024 at 07:08:52PM +0200, Yordan Karadzhov wrote:
>> Hi Benjamin,
>>
>> I am applying most of the patches from your patch-set. I have some minor
>> comments about few of the changes that I will make in the individual
>> patches.
>>
>> Once again, thanks a lot for helping us to improve kernelshark!
>>
>> Cheers,
>> Yordan
>>
> 
> Hi Yordan,
> 
> Do you think it is possible to create a new release since all the major bugs
> were resolved?
> Indeed, the KernelShark version 2.3.0 is currently not usable, and this is this
> version that is provided in the Arch repository. The Arch maintainers would
> prefer a new release instead of applying a ton of patches.
> 
> Thanks,
> Benjamin
>   
>> On 1/14/24 19:16, Benjamin ROBIN wrote:
>>> There were 3 majors issues:
>>>    - A segfault when loading a trace file (patch 0001)
>>>    - The trace table height was very small (patch 0032)
>>>    - The trace table columns width were reducing when clicking
>>>      Marker A or B (patch 0032)
>>>
>>> Also fix most of the warnings reported by Clang-Tidy and Clazy, and by
>>> gcc with -Wextra.
>>>
>>>
>>> Benjamin ROBIN (34):
>>>     kernelshark: Fix modelReset() signaling, rename update to updateGeom
>>>     kernelshark: Add .gitignore
>>>     kernelshark: Remove function param when not used, whenever possible
>>>     kernelshark: Do not create a temporary container for looping over QMap
>>>     kernelshark: Prevent potential detach of QMap container
>>>     kernelshark: Fix used after free of QByteArray raw data
>>>     kernelshark: Fix potential memory leak in KsGLWidget
>>>     kernelshark: Use lambda parameter instead of captured local variable
>>>     kernelshark: Keep overridden method protected instead of public
>>>     kernelshark: Use sliced() or first() instead of mid/right/left()
>>>     kernelshark: Prevent potential divide by zero in Shape::center()
>>>     kernelshark: Fix potential access to uninitialized variable
>>>     kernelshark: Remove unused locals variables
>>>     kernelshark: Fix range-loop-reference Clazy warning
>>>     kernelshark: Fix moving a temp object prevents copy elision warning
>>>     kernelshark: Add receiver object to connect() call
>>>     kernelshark: Return by reference the list of header in KsModels
>>>     kernelshark: Fix detaching-temporary Clazy warning
>>>     kernelshark: Fix qfileinfo-exists Clazy warning
>>>     kernelshark: Fix potential memory leaks in libkshark-configio
>>>     kernelshark: Fix potential access to uninitialized variable
>>>     kernelshark: Fix potential double free of histo->map, histo->bin_count
>>>     kernelshark: Fix 'const' type qualifier on return type has no effect
>>>     kernelshark: Fix potential memory leaks in libkshark-tepdata
>>>     kernelshark: Fix typo in comment of KsGLWidget::resizeGL()
>>>     kernelshark: Remove unused KsDataWidget::wipPtr() and broken function
>>>     kernelshark: In KsTimeOffsetDialog() constructor use parent param
>>>     kernelshark: Fixed loop counter incremented suspiciously twice
>>>     kernelshark: Fix tepdata_dump_entry() for event_id = KS_EVENT_OVERFLOW
>>>     kernelshark: Use static_cast instead of C cast in KsMainWindow
>>>     kernelshark: Fix comparison of integers of different signs warnings
>>>     kernelshark: Fix KsTableView columns width, and KsTraceViewer size
>>>     kernelshark: Allow to reduce a bit more the graph height
>>>     kernelshark: Cleanup of KsDualMarker methods
>>>
>>>    .gitignore                     | 15 ++++++
>>>    examples/configio.c            |  3 +-
>>>    examples/datafilter.c          | 15 +++---
>>>    examples/datahisto.c           |  2 +-
>>>    src/KsAdvFilteringDialog.cpp   | 24 ++++------
>>>    src/KsAdvFilteringDialog.hpp   |  2 +-
>>>    src/KsDualMarker.hpp           | 10 +---
>>>    src/KsGLWidget.cpp             | 48 +++++++++----------
>>>    src/KsGLWidget.hpp             | 43 ++++++++---------
>>>    src/KsMainWindow.cpp           |  8 ++--
>>>    src/KsModels.hpp               | 11 +++--
>>>    src/KsPlotTools.cpp            | 14 +++---
>>>    src/KsPlotTools.hpp            |  2 +-
>>>    src/KsSession.cpp              |  4 +-
>>>    src/KsTraceGraph.cpp           |  7 ++-
>>>    src/KsTraceViewer.cpp          | 71 ++++++++--------------------
>>>    src/KsTraceViewer.hpp          | 11 +++--
>>>    src/KsUtils.cpp                |  9 ++--
>>>    src/KsUtils.hpp                |  4 +-
>>>    src/KsWidgetsLib.cpp           |  2 +-
>>>    src/KsWidgetsLib.hpp           | 15 ++----
>>>    src/libkshark-collection.c     | 14 +++---
>>>    src/libkshark-configio.c       | 84 +++++++++++++++++++---------------
>>>    src/libkshark-hash.c           |  5 +-
>>>    src/libkshark-model.c          | 19 ++++----
>>>    src/libkshark-tepdata.c        | 31 ++++++++-----
>>>    src/libkshark.c                | 17 +++----
>>>    src/libkshark.h                | 20 ++++----
>>>    src/plugins/KVMComboDialog.cpp |  7 +--
>>>    src/plugins/sched_events.c     |  2 +-
>>>    tests/test-input.c             |  4 +-
>>>    tests/test-input_ctrl.c        |  4 +-
>>>    32 files changed, 257 insertions(+), 270 deletions(-)
>>>    create mode 100644 .gitignore
>>>
>>> --
>>> 2.43.0
>>>
