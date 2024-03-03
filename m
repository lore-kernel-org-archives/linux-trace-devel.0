Received: from 4.mo552.mail-out.ovh.net (4.mo552.mail-out.ovh.net [178.33.43.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE206AD2C
	for <linux-trace-devel@vger.kernel.org>; Sun,  3 Mar 2024 09:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.33.43.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709459798; cv=none; b=lmdAQV0gATT6Q4AL1oXiMFBL0S9RC+xIVhtKXaX67sY7vvDb3+JdJGGf1qHydhsqtzzU7uUukLBsBYLcH2TGHCHh/XVI3Bkgxb6lEwUVdFpEHz6AJRXd8/mMDkvCrsYi6WuJh6jG4/C1FKxktlrU6t6GUUUA8/3tlVGu4UVVHyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709459798; c=relaxed/simple;
	bh=Lflyez3eSHT2T2yRDnpAQ1FUkkVuuaBWdEJwLBLYNbY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PDlt5Q6hhYAYYdORI1MTpN3X37wxKK80uWssQhOrvrboObClZkwxEwTb4BrOaZun2+qqZlUvtLg6CIFqwxDYKsZuE+p3+NeZt1idEOi0FbNmgQMkcOcv1F7F+y3CBdb8ii/zW95rCsByJU1oRufBGDqeWRgogbzymOMp/xBHO0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr; spf=pass smtp.mailfrom=benjarobin.fr; arc=none smtp.client-ip=178.33.43.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benjarobin.fr
Received: from mxplan5.mail.ovh.net (unknown [10.108.2.90])
	by mo552.mail-out.ovh.net (Postfix) with ESMTPS id 4Tncfc6PCzz17vT;
	Sun,  3 Mar 2024 09:56:24 +0000 (UTC)
Received: from benjarobin.fr (37.59.142.96) by DAG6EX2.mxp5.local
 (172.16.2.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 3 Mar
 2024 10:56:24 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-96R001603ebf9a-f515-42fd-b48e-e75fe9f7f18a,
                    141FE5F4A721788577D32EEEC7F7D89AB67260F8) smtp.auth=dev@benjarobin.fr
X-OVh-ClientIp: 92.161.126.4
Date: Sun, 3 Mar 2024 10:56:22 +0100
From: Benjamin ROBIN <dev@benjarobin.fr>
To: Yordan Karadzhov <y.karadz@gmail.com>
CC: <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 00/34] Fix kernelshark issues introduced by the migration
 to Qt6
Message-ID: <vr7u3h23fq5ugctpdm2vqsgk3oj47c6bttf52m2gyic7zcf5fr@35zvpfc7zodq>
References: <20240114171723.14092-1-dev@benjarobin.fr>
 <81d345f5-5352-1a2f-e18e-72ad0d9a6788@gmail.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <81d345f5-5352-1a2f-e18e-72ad0d9a6788@gmail.com>
X-ClientProxiedBy: DAG8EX1.mxp5.local (172.16.2.71) To DAG6EX2.mxp5.local
 (172.16.2.52)
X-Ovh-Tracer-GUID: d6ffba0f-e522-4021-b826-90a6bdf074c9
X-Ovh-Tracer-Id: 5280470566290546586
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvledrheehgddtlecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeffhffvvefukfhfgggtuggjihesthdtsfdttddtvdenucfhrhhomhepuegvnhhjrghmihhnucftqfeukffpuceouggvvhessggvnhhjrghrohgsihhnrdhfrheqnecuggftrfgrthhtvghrnhepteelffekfefflefftdeuffeflefhjeevjedujeeikeejfeetudfgtdeuuefhgeehnecukfhppeduvdejrddtrddtrddupdefjedrheelrddugedvrdeliedpledvrdduiedurdduvdeirdegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeguvghvsegsvghnjhgrrhhosghinhdrfhhrpdhnsggprhgtphhtthhopedvpdhrtghpthhtohephidrkhgrrhgrugiisehgmhgrihhlrdgtohhmpdhrtghpthhtoheplhhinhhugidqthhrrggtvgdquggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpoffvtefjohhsthepmhhoheehvddpmhhouggvpehsmhhtphhouhht

On Sun, Jan 21, 2024 at 07:08:52PM +0200, Yordan Karadzhov wrote:
> Hi Benjamin,
> 
> I am applying most of the patches from your patch-set. I have some minor
> comments about few of the changes that I will make in the individual
> patches.
> 
> Once again, thanks a lot for helping us to improve kernelshark!
> 
> Cheers,
> Yordan
>

Hi Yordan,

Do you think it is possible to create a new release since all the major bugs 
were resolved?
Indeed, the KernelShark version 2.3.0 is currently not usable, and this is this 
version that is provided in the Arch repository. The Arch maintainers would 
prefer a new release instead of applying a ton of patches.

Thanks,
Benjamin
 
> On 1/14/24 19:16, Benjamin ROBIN wrote:
> > There were 3 majors issues:
> >   - A segfault when loading a trace file (patch 0001)
> >   - The trace table height was very small (patch 0032)
> >   - The trace table columns width were reducing when clicking
> >     Marker A or B (patch 0032)
> > 
> > Also fix most of the warnings reported by Clang-Tidy and Clazy, and by
> > gcc with -Wextra.
> > 
> > 
> > Benjamin ROBIN (34):
> >    kernelshark: Fix modelReset() signaling, rename update to updateGeom
> >    kernelshark: Add .gitignore
> >    kernelshark: Remove function param when not used, whenever possible
> >    kernelshark: Do not create a temporary container for looping over QMap
> >    kernelshark: Prevent potential detach of QMap container
> >    kernelshark: Fix used after free of QByteArray raw data
> >    kernelshark: Fix potential memory leak in KsGLWidget
> >    kernelshark: Use lambda parameter instead of captured local variable
> >    kernelshark: Keep overridden method protected instead of public
> >    kernelshark: Use sliced() or first() instead of mid/right/left()
> >    kernelshark: Prevent potential divide by zero in Shape::center()
> >    kernelshark: Fix potential access to uninitialized variable
> >    kernelshark: Remove unused locals variables
> >    kernelshark: Fix range-loop-reference Clazy warning
> >    kernelshark: Fix moving a temp object prevents copy elision warning
> >    kernelshark: Add receiver object to connect() call
> >    kernelshark: Return by reference the list of header in KsModels
> >    kernelshark: Fix detaching-temporary Clazy warning
> >    kernelshark: Fix qfileinfo-exists Clazy warning
> >    kernelshark: Fix potential memory leaks in libkshark-configio
> >    kernelshark: Fix potential access to uninitialized variable
> >    kernelshark: Fix potential double free of histo->map, histo->bin_count
> >    kernelshark: Fix 'const' type qualifier on return type has no effect
> >    kernelshark: Fix potential memory leaks in libkshark-tepdata
> >    kernelshark: Fix typo in comment of KsGLWidget::resizeGL()
> >    kernelshark: Remove unused KsDataWidget::wipPtr() and broken function
> >    kernelshark: In KsTimeOffsetDialog() constructor use parent param
> >    kernelshark: Fixed loop counter incremented suspiciously twice
> >    kernelshark: Fix tepdata_dump_entry() for event_id = KS_EVENT_OVERFLOW
> >    kernelshark: Use static_cast instead of C cast in KsMainWindow
> >    kernelshark: Fix comparison of integers of different signs warnings
> >    kernelshark: Fix KsTableView columns width, and KsTraceViewer size
> >    kernelshark: Allow to reduce a bit more the graph height
> >    kernelshark: Cleanup of KsDualMarker methods
> > 
> >   .gitignore                     | 15 ++++++
> >   examples/configio.c            |  3 +-
> >   examples/datafilter.c          | 15 +++---
> >   examples/datahisto.c           |  2 +-
> >   src/KsAdvFilteringDialog.cpp   | 24 ++++------
> >   src/KsAdvFilteringDialog.hpp   |  2 +-
> >   src/KsDualMarker.hpp           | 10 +---
> >   src/KsGLWidget.cpp             | 48 +++++++++----------
> >   src/KsGLWidget.hpp             | 43 ++++++++---------
> >   src/KsMainWindow.cpp           |  8 ++--
> >   src/KsModels.hpp               | 11 +++--
> >   src/KsPlotTools.cpp            | 14 +++---
> >   src/KsPlotTools.hpp            |  2 +-
> >   src/KsSession.cpp              |  4 +-
> >   src/KsTraceGraph.cpp           |  7 ++-
> >   src/KsTraceViewer.cpp          | 71 ++++++++--------------------
> >   src/KsTraceViewer.hpp          | 11 +++--
> >   src/KsUtils.cpp                |  9 ++--
> >   src/KsUtils.hpp                |  4 +-
> >   src/KsWidgetsLib.cpp           |  2 +-
> >   src/KsWidgetsLib.hpp           | 15 ++----
> >   src/libkshark-collection.c     | 14 +++---
> >   src/libkshark-configio.c       | 84 +++++++++++++++++++---------------
> >   src/libkshark-hash.c           |  5 +-
> >   src/libkshark-model.c          | 19 ++++----
> >   src/libkshark-tepdata.c        | 31 ++++++++-----
> >   src/libkshark.c                | 17 +++----
> >   src/libkshark.h                | 20 ++++----
> >   src/plugins/KVMComboDialog.cpp |  7 +--
> >   src/plugins/sched_events.c     |  2 +-
> >   tests/test-input.c             |  4 +-
> >   tests/test-input_ctrl.c        |  4 +-
> >   32 files changed, 257 insertions(+), 270 deletions(-)
> >   create mode 100644 .gitignore
> > 
> > --
> > 2.43.0
> > 
