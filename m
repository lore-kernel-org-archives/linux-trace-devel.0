Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FCB6CDB6
	for <linux-trace-devel@vger.kernel.org>; Sun,  3 Mar 2024 20:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709498670; cv=none; b=cTTY5kUw+xvCMZGtbWPlZnZVHJe+5pGQz4boZ7ht8t3tbp4KbMwNYiip7MyvZQ+Robd9c6Oxq9z1bpcvVj3nfRJNeUoyXnHEz7Ug62PCUiOuXQHHJhNhxW8gGZ0UFeCx/RETyd44IBWRu91JxVCXY7sP0bCa2oEmBzCwIb5PK14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709498670; c=relaxed/simple;
	bh=SG80IEiWmiD8N5NlBmaiIRNnwvaPYiPJTxNZJL76r7Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j+lTIZXUfz787tYOUxe2xIPPCqi78qlqpSdsTNt3hCfUEOu8sR4WBkCelNFjRq45klQ/pVugDfkuR9q4yhpWnyHBGpPFiOl5w5RgAK01DZMcrZTvkrdBEPtpWG6kZ9G3MoY23PnoUdJfYHZ86YAQzsmTIyrpOghYnDZBkWov/98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jiw2PwTz; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jiw2PwTz"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a450615d1c4so123266166b.0
        for <linux-trace-devel@vger.kernel.org>; Sun, 03 Mar 2024 12:44:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709498667; x=1710103467; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fHcJdqG812MYCwfYWItAxcYf0jf5CqizGeVtbxo+axY=;
        b=jiw2PwTzJKJaM0xSs/CdZuQsFBReq6ENZC04eIOxcAJovyJ/rB7gyQPU7i1wwUp1if
         z7z41kYeDuGpgw1QamwqVyh9awkxvyWqe9svgHKF5FUheqWOsZnrv0uHBq2CXNkMqc4i
         PObxljabMauxoJBUYPamc2g8rjxAJbTbVuEsv4K3bCGw7enkPhnowf+N0RASHVJvn/O0
         Ixm9zjm92vRkDRHraFd2OIiONqrckYQwfWyy5TPVR7XFOvvAbcNQjl4If9HNTHZq1iiT
         vuh83hC0KU6PRIQbJyZsyfm+l5g58BMVPh88bkAg2E3rZMLglHfPt4wDgarMwsv4fbrB
         koiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709498667; x=1710103467;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fHcJdqG812MYCwfYWItAxcYf0jf5CqizGeVtbxo+axY=;
        b=hwi/6tb4Waz+gmLL5QrOV5EtwG/32bMQJwGclOy+E4/t+attcDej+CKnXDW4j+Mb5m
         +83Bh0QzfFJ8e333nAYBqE4NyY0mDebqmxO++SORVHJNB9N1DQPWyhSL5OG/iubu0ilN
         B5KL3Cze2wWoAvzzdH6sixxEMafSGK+xD+AiOLQTcazEjECJPKxyLO4PZ9MDejXJyyGD
         5Phu1nLGrHEq4OyAwqvl7RBrv8FZan00ey5SdbqRAd/FbuQ+IZ7yiR6bIC4bwcj8aEzd
         gxcxWXIDGqeAlKiZ36TfSqX0VGvSFs/mUkX02L3sJmtDaYSjrA4WgB0hfW6FvA89fPOC
         GJ0Q==
X-Gm-Message-State: AOJu0YxRj49ZF0bRlXB5U1wj7Zc/oE0BXazPr/PGoKBxPqUhAm05T7n2
	Y5VfqtlpZL+G13AQq5AyHi+3AYsV/blwUbHL6RYIfV0yenz478Vb6Nl/MCbZxCxH55QSyX4o8qQ
	HNCvtqx9ixTLzS2KFLRrYlOxtjUczNX3eVEs=
X-Google-Smtp-Source: AGHT+IEcdv7iOq7LtWHgk+UNikMOQiXwYsnSc+Td0kdcgmlGo+Lptl/FNDbKkexp0b5IsQHxF1MhlU8HgCQfVOibn6o=
X-Received: by 2002:a17:906:6a1d:b0:a44:9483:33c1 with SMTP id
 qw29-20020a1709066a1d00b00a44948333c1mr6918275ejc.20.1709498666717; Sun, 03
 Mar 2024 12:44:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240114171723.14092-1-dev@benjarobin.fr> <81d345f5-5352-1a2f-e18e-72ad0d9a6788@gmail.com>
 <vr7u3h23fq5ugctpdm2vqsgk3oj47c6bttf52m2gyic7zcf5fr@35zvpfc7zodq>
 <5f716366-4dd0-6b36-f12d-73f3ad4d8c5c@gmail.com> <CADVatmO1ekwDdE6UsYk1909-8bxfUYTp+S8d59bg2kv7ZyQTDQ@mail.gmail.com>
In-Reply-To: <CADVatmO1ekwDdE6UsYk1909-8bxfUYTp+S8d59bg2kv7ZyQTDQ@mail.gmail.com>
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date: Sun, 3 Mar 2024 20:43:49 +0000
Message-ID: <CADVatmOg5XzUdgZOZ7gDX3Qf6TAw3m19Waeg0=LjFsvYCPx3gw@mail.gmail.com>
Subject: Re: [PATCH 00/34] Fix kernelshark issues introduced by the migration
 to Qt6
To: Yordan Karadzhov <y.karadz@gmail.com>, Benjamin ROBIN <dev@benjarobin.fr>
Cc: linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

I have now tested and can confirm that the patches from Benjamin has
fixed the problem I was seeing on Debian also. A new release will be
better for me also, instead of adding all those patches to Debian
package.

Thanks Benjamin for the fixes.

-- 
Regards
Sudip

On Sun, 3 Mar 2024 at 17:07, Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:
>
> Looking at these patches I think my issue should be fixed now. Let me
> try the latest HEAD tonight.
>
>
> --
> Regards
> Sudip
>
>
> On Sun, 3 Mar 2024 at 15:47, Yordan Karadzhov <y.karadz@gmail.com> wrote:
> >
> > Hi Benjamin,
> >
> > We still have one unresolved bug that was reported by Sudip.
> > I will do my best to get this sorted out and have a new release by the
> > end of next week.
> >
> > Thanks,
> > Y.
> >
> > On 3/3/24 11:56, Benjamin ROBIN wrote:
> > > On Sun, Jan 21, 2024 at 07:08:52PM +0200, Yordan Karadzhov wrote:
> > >> Hi Benjamin,
> > >>
> > >> I am applying most of the patches from your patch-set. I have some minor
> > >> comments about few of the changes that I will make in the individual
> > >> patches.
> > >>
> > >> Once again, thanks a lot for helping us to improve kernelshark!
> > >>
> > >> Cheers,
> > >> Yordan
> > >>
> > >
> > > Hi Yordan,
> > >
> > > Do you think it is possible to create a new release since all the major bugs
> > > were resolved?
> > > Indeed, the KernelShark version 2.3.0 is currently not usable, and this is this
> > > version that is provided in the Arch repository. The Arch maintainers would
> > > prefer a new release instead of applying a ton of patches.
> > >
> > > Thanks,
> > > Benjamin
> > >
> > >> On 1/14/24 19:16, Benjamin ROBIN wrote:
> > >>> There were 3 majors issues:
> > >>>    - A segfault when loading a trace file (patch 0001)
> > >>>    - The trace table height was very small (patch 0032)
> > >>>    - The trace table columns width were reducing when clicking
> > >>>      Marker A or B (patch 0032)
> > >>>
> > >>> Also fix most of the warnings reported by Clang-Tidy and Clazy, and by
> > >>> gcc with -Wextra.
> > >>>
> > >>>
> > >>> Benjamin ROBIN (34):
> > >>>     kernelshark: Fix modelReset() signaling, rename update to updateGeom
> > >>>     kernelshark: Add .gitignore
> > >>>     kernelshark: Remove function param when not used, whenever possible
> > >>>     kernelshark: Do not create a temporary container for looping over QMap
> > >>>     kernelshark: Prevent potential detach of QMap container
> > >>>     kernelshark: Fix used after free of QByteArray raw data
> > >>>     kernelshark: Fix potential memory leak in KsGLWidget
> > >>>     kernelshark: Use lambda parameter instead of captured local variable
> > >>>     kernelshark: Keep overridden method protected instead of public
> > >>>     kernelshark: Use sliced() or first() instead of mid/right/left()
> > >>>     kernelshark: Prevent potential divide by zero in Shape::center()
> > >>>     kernelshark: Fix potential access to uninitialized variable
> > >>>     kernelshark: Remove unused locals variables
> > >>>     kernelshark: Fix range-loop-reference Clazy warning
> > >>>     kernelshark: Fix moving a temp object prevents copy elision warning
> > >>>     kernelshark: Add receiver object to connect() call
> > >>>     kernelshark: Return by reference the list of header in KsModels
> > >>>     kernelshark: Fix detaching-temporary Clazy warning
> > >>>     kernelshark: Fix qfileinfo-exists Clazy warning
> > >>>     kernelshark: Fix potential memory leaks in libkshark-configio
> > >>>     kernelshark: Fix potential access to uninitialized variable
> > >>>     kernelshark: Fix potential double free of histo->map, histo->bin_count
> > >>>     kernelshark: Fix 'const' type qualifier on return type has no effect
> > >>>     kernelshark: Fix potential memory leaks in libkshark-tepdata
> > >>>     kernelshark: Fix typo in comment of KsGLWidget::resizeGL()
> > >>>     kernelshark: Remove unused KsDataWidget::wipPtr() and broken function
> > >>>     kernelshark: In KsTimeOffsetDialog() constructor use parent param
> > >>>     kernelshark: Fixed loop counter incremented suspiciously twice
> > >>>     kernelshark: Fix tepdata_dump_entry() for event_id = KS_EVENT_OVERFLOW
> > >>>     kernelshark: Use static_cast instead of C cast in KsMainWindow
> > >>>     kernelshark: Fix comparison of integers of different signs warnings
> > >>>     kernelshark: Fix KsTableView columns width, and KsTraceViewer size
> > >>>     kernelshark: Allow to reduce a bit more the graph height
> > >>>     kernelshark: Cleanup of KsDualMarker methods
> > >>>
> > >>>    .gitignore                     | 15 ++++++
> > >>>    examples/configio.c            |  3 +-
> > >>>    examples/datafilter.c          | 15 +++---
> > >>>    examples/datahisto.c           |  2 +-
> > >>>    src/KsAdvFilteringDialog.cpp   | 24 ++++------
> > >>>    src/KsAdvFilteringDialog.hpp   |  2 +-
> > >>>    src/KsDualMarker.hpp           | 10 +---
> > >>>    src/KsGLWidget.cpp             | 48 +++++++++----------
> > >>>    src/KsGLWidget.hpp             | 43 ++++++++---------
> > >>>    src/KsMainWindow.cpp           |  8 ++--
> > >>>    src/KsModels.hpp               | 11 +++--
> > >>>    src/KsPlotTools.cpp            | 14 +++---
> > >>>    src/KsPlotTools.hpp            |  2 +-
> > >>>    src/KsSession.cpp              |  4 +-
> > >>>    src/KsTraceGraph.cpp           |  7 ++-
> > >>>    src/KsTraceViewer.cpp          | 71 ++++++++--------------------
> > >>>    src/KsTraceViewer.hpp          | 11 +++--
> > >>>    src/KsUtils.cpp                |  9 ++--
> > >>>    src/KsUtils.hpp                |  4 +-
> > >>>    src/KsWidgetsLib.cpp           |  2 +-
> > >>>    src/KsWidgetsLib.hpp           | 15 ++----
> > >>>    src/libkshark-collection.c     | 14 +++---
> > >>>    src/libkshark-configio.c       | 84 +++++++++++++++++++---------------
> > >>>    src/libkshark-hash.c           |  5 +-
> > >>>    src/libkshark-model.c          | 19 ++++----
> > >>>    src/libkshark-tepdata.c        | 31 ++++++++-----
> > >>>    src/libkshark.c                | 17 +++----
> > >>>    src/libkshark.h                | 20 ++++----
> > >>>    src/plugins/KVMComboDialog.cpp |  7 +--
> > >>>    src/plugins/sched_events.c     |  2 +-
> > >>>    tests/test-input.c             |  4 +-
> > >>>    tests/test-input_ctrl.c        |  4 +-
> > >>>    32 files changed, 257 insertions(+), 270 deletions(-)
> > >>>    create mode 100644 .gitignore
> > >>>
> > >>> --
> > >>> 2.43.0
> > >>>
