Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F897762E6
	for <linux-trace-devel@vger.kernel.org>; Sun,  3 Mar 2024 17:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709485710; cv=none; b=B40xbkOvn1rP/y739nmUVmQCx/u31Rg5l3REAgIFTC4tLlCc0lYXNyYkq5a95QhpGx0EqtPdZpD1yQ+mtVf3bfFM8CQNfxTMF4WQwFDrvEZnVkSp2Zx8GkV0PVklJQogbHs6qQ3CmJy0AHjxqrgEMKyabg9HZWulbWcxBnG9D7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709485710; c=relaxed/simple;
	bh=BuK4pvhIHL/0Owsl11QpIzNhfUZvJ2kNCNJZOgpDK0I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K4I4RcntXBWLVFLeqOleJSvQwMLr8hGYx3GgbEKAXP6+lp06dqrIh4LJwEigvk/t/1oJ6tGkK9N26Zg31IgcEA2JTk79KECuS92zK1s4SkKNwyhRTJv+58re9rmpbEEmB5ICK5XsxC2dwjmNCorxb5wATmZMGgBlTd4ADyM6ptA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mggUvV0p; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mggUvV0p"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a44ad785a44so239462566b.3
        for <linux-trace-devel@vger.kernel.org>; Sun, 03 Mar 2024 09:08:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709485707; x=1710090507; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=z9Ny8Rtw83xq4PqXQghL3A1GTjLe7tINr8s9sSOQ5j0=;
        b=mggUvV0pKiNm50Be9Wkn6LscJTeGW85KG+8ucM3jozv8uYM4y6LyjaRVkhzaX7k7VB
         k49jiyYVT/35+v8d1lv1apuM3Td2nF1RoQAm5JN9hq1G/ktPY1ldOStXiol3UJFjMGen
         O81bY0qXaOyQqOQ6EhLYh8LxvG19MVlp4jc2MIPORq9RAlcEXBzlHS8ikEJoZu1NtRwb
         b7Eo6xwj/MFj/9f1FpNW131ehNDrRWruENvjzkOW9rbiMMCYVX2wkU0eKsomNHJj1P46
         wULarVpsnk4yMX3LgkElJg3zcKLyHLS5mjApr53PJ3RoYXRLdyq/J5+61XMHdOG9XEzr
         21lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709485707; x=1710090507;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z9Ny8Rtw83xq4PqXQghL3A1GTjLe7tINr8s9sSOQ5j0=;
        b=OwiyugEI8eP1RAYyzdO6qR+vNBMpnjA++BHq8JERmB+aSP0UT+c7cUGxmpQbGQRYuO
         iV+LLtylECf/jwTObmnRWG1BZraHVf/762r8xuw2uViR3JGtx2Ycp8IzUVhOAzP7HbSq
         Fjho+uCJYr9g7nFL406/cA1oTY0FkY3HQJqMYNvBHNJXcdvS267yTCz7CuA9MN6Hzciq
         svbqW3mKF4SUsTBXQbxvTERMNSY5XJSV87m2fITTkxh7yH6Yk/aXcL1jjQucVSRE4lHi
         L/NpEmTpIgxeO3rTMdGpOoj6GG0j1+q7gYDyyT7fFLe1s2wr55gPaKeqjl6MJBcdSO2t
         AUuw==
X-Forwarded-Encrypted: i=1; AJvYcCVWgeJG0z/NePKmW1UzL8JNbhB2cWSu9RaQ0xZGaCOUGr+RRjjqygcx3yGUkgMxCfda4kNRheDqLkyjQpPkx6usrH8Kahf7/cUtmA7ANV48WeQ=
X-Gm-Message-State: AOJu0YwnZ0Lk3OLDKxrK4H4JFTAOGQfXGfn+DvyO/vYuPKeqa4LyVFPJ
	BvDG2RUZEGefV9zj6BeDaKPdmWhgKjQvHf1YCTTnQFBi4sqar7z1abTHyKky+VjLmOMxHTqqFZt
	kIphhYPen0AQIqIvHaD81NNIsRx/E6QGeWTs=
X-Google-Smtp-Source: AGHT+IEYPxlPak6gsRPlB3Jz0KO36hZHYeqV+zkf+y6Bsd3Gc+wfg2dHxu+fNp4P80HAS88P/wNgfw+k4tLzKIbG8ZY=
X-Received: by 2002:a17:906:3508:b0:a44:d042:887b with SMTP id
 r8-20020a170906350800b00a44d042887bmr2301230eja.8.1709485706578; Sun, 03 Mar
 2024 09:08:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240114171723.14092-1-dev@benjarobin.fr> <81d345f5-5352-1a2f-e18e-72ad0d9a6788@gmail.com>
 <vr7u3h23fq5ugctpdm2vqsgk3oj47c6bttf52m2gyic7zcf5fr@35zvpfc7zodq> <5f716366-4dd0-6b36-f12d-73f3ad4d8c5c@gmail.com>
In-Reply-To: <5f716366-4dd0-6b36-f12d-73f3ad4d8c5c@gmail.com>
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date: Sun, 3 Mar 2024 17:07:49 +0000
Message-ID: <CADVatmO1ekwDdE6UsYk1909-8bxfUYTp+S8d59bg2kv7ZyQTDQ@mail.gmail.com>
Subject: Re: [PATCH 00/34] Fix kernelshark issues introduced by the migration
 to Qt6
To: Yordan Karadzhov <y.karadz@gmail.com>
Cc: Benjamin ROBIN <dev@benjarobin.fr>, linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Looking at these patches I think my issue should be fixed now. Let me
try the latest HEAD tonight.


-- 
Regards
Sudip


On Sun, 3 Mar 2024 at 15:47, Yordan Karadzhov <y.karadz@gmail.com> wrote:
>
> Hi Benjamin,
>
> We still have one unresolved bug that was reported by Sudip.
> I will do my best to get this sorted out and have a new release by the
> end of next week.
>
> Thanks,
> Y.
>
> On 3/3/24 11:56, Benjamin ROBIN wrote:
> > On Sun, Jan 21, 2024 at 07:08:52PM +0200, Yordan Karadzhov wrote:
> >> Hi Benjamin,
> >>
> >> I am applying most of the patches from your patch-set. I have some minor
> >> comments about few of the changes that I will make in the individual
> >> patches.
> >>
> >> Once again, thanks a lot for helping us to improve kernelshark!
> >>
> >> Cheers,
> >> Yordan
> >>
> >
> > Hi Yordan,
> >
> > Do you think it is possible to create a new release since all the major bugs
> > were resolved?
> > Indeed, the KernelShark version 2.3.0 is currently not usable, and this is this
> > version that is provided in the Arch repository. The Arch maintainers would
> > prefer a new release instead of applying a ton of patches.
> >
> > Thanks,
> > Benjamin
> >
> >> On 1/14/24 19:16, Benjamin ROBIN wrote:
> >>> There were 3 majors issues:
> >>>    - A segfault when loading a trace file (patch 0001)
> >>>    - The trace table height was very small (patch 0032)
> >>>    - The trace table columns width were reducing when clicking
> >>>      Marker A or B (patch 0032)
> >>>
> >>> Also fix most of the warnings reported by Clang-Tidy and Clazy, and by
> >>> gcc with -Wextra.
> >>>
> >>>
> >>> Benjamin ROBIN (34):
> >>>     kernelshark: Fix modelReset() signaling, rename update to updateGeom
> >>>     kernelshark: Add .gitignore
> >>>     kernelshark: Remove function param when not used, whenever possible
> >>>     kernelshark: Do not create a temporary container for looping over QMap
> >>>     kernelshark: Prevent potential detach of QMap container
> >>>     kernelshark: Fix used after free of QByteArray raw data
> >>>     kernelshark: Fix potential memory leak in KsGLWidget
> >>>     kernelshark: Use lambda parameter instead of captured local variable
> >>>     kernelshark: Keep overridden method protected instead of public
> >>>     kernelshark: Use sliced() or first() instead of mid/right/left()
> >>>     kernelshark: Prevent potential divide by zero in Shape::center()
> >>>     kernelshark: Fix potential access to uninitialized variable
> >>>     kernelshark: Remove unused locals variables
> >>>     kernelshark: Fix range-loop-reference Clazy warning
> >>>     kernelshark: Fix moving a temp object prevents copy elision warning
> >>>     kernelshark: Add receiver object to connect() call
> >>>     kernelshark: Return by reference the list of header in KsModels
> >>>     kernelshark: Fix detaching-temporary Clazy warning
> >>>     kernelshark: Fix qfileinfo-exists Clazy warning
> >>>     kernelshark: Fix potential memory leaks in libkshark-configio
> >>>     kernelshark: Fix potential access to uninitialized variable
> >>>     kernelshark: Fix potential double free of histo->map, histo->bin_count
> >>>     kernelshark: Fix 'const' type qualifier on return type has no effect
> >>>     kernelshark: Fix potential memory leaks in libkshark-tepdata
> >>>     kernelshark: Fix typo in comment of KsGLWidget::resizeGL()
> >>>     kernelshark: Remove unused KsDataWidget::wipPtr() and broken function
> >>>     kernelshark: In KsTimeOffsetDialog() constructor use parent param
> >>>     kernelshark: Fixed loop counter incremented suspiciously twice
> >>>     kernelshark: Fix tepdata_dump_entry() for event_id = KS_EVENT_OVERFLOW
> >>>     kernelshark: Use static_cast instead of C cast in KsMainWindow
> >>>     kernelshark: Fix comparison of integers of different signs warnings
> >>>     kernelshark: Fix KsTableView columns width, and KsTraceViewer size
> >>>     kernelshark: Allow to reduce a bit more the graph height
> >>>     kernelshark: Cleanup of KsDualMarker methods
> >>>
> >>>    .gitignore                     | 15 ++++++
> >>>    examples/configio.c            |  3 +-
> >>>    examples/datafilter.c          | 15 +++---
> >>>    examples/datahisto.c           |  2 +-
> >>>    src/KsAdvFilteringDialog.cpp   | 24 ++++------
> >>>    src/KsAdvFilteringDialog.hpp   |  2 +-
> >>>    src/KsDualMarker.hpp           | 10 +---
> >>>    src/KsGLWidget.cpp             | 48 +++++++++----------
> >>>    src/KsGLWidget.hpp             | 43 ++++++++---------
> >>>    src/KsMainWindow.cpp           |  8 ++--
> >>>    src/KsModels.hpp               | 11 +++--
> >>>    src/KsPlotTools.cpp            | 14 +++---
> >>>    src/KsPlotTools.hpp            |  2 +-
> >>>    src/KsSession.cpp              |  4 +-
> >>>    src/KsTraceGraph.cpp           |  7 ++-
> >>>    src/KsTraceViewer.cpp          | 71 ++++++++--------------------
> >>>    src/KsTraceViewer.hpp          | 11 +++--
> >>>    src/KsUtils.cpp                |  9 ++--
> >>>    src/KsUtils.hpp                |  4 +-
> >>>    src/KsWidgetsLib.cpp           |  2 +-
> >>>    src/KsWidgetsLib.hpp           | 15 ++----
> >>>    src/libkshark-collection.c     | 14 +++---
> >>>    src/libkshark-configio.c       | 84 +++++++++++++++++++---------------
> >>>    src/libkshark-hash.c           |  5 +-
> >>>    src/libkshark-model.c          | 19 ++++----
> >>>    src/libkshark-tepdata.c        | 31 ++++++++-----
> >>>    src/libkshark.c                | 17 +++----
> >>>    src/libkshark.h                | 20 ++++----
> >>>    src/plugins/KVMComboDialog.cpp |  7 +--
> >>>    src/plugins/sched_events.c     |  2 +-
> >>>    tests/test-input.c             |  4 +-
> >>>    tests/test-input_ctrl.c        |  4 +-
> >>>    32 files changed, 257 insertions(+), 270 deletions(-)
> >>>    create mode 100644 .gitignore
> >>>
> >>> --
> >>> 2.43.0
> >>>
