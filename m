Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.121
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795008664;
	b=bmmfeVkamsqhFq9Te4FtFrUE3oPlZxQVS77iL5lmM3AKbDqpdL6hf8G99zYQ76sOXlzH
	 l5InBgD4unVW7RNnbFIsQ8kt0v7K2VMwopjADIGD7u2T5TZs6tppmdAG8CovGqqzMCm4m
	 ElBTYSwNw52aBB5vQ9slGdEBTzVvcDm/9J4cajjTaL2fczwqDhORX9V0fZnlf1F4+k45/
	 8fTjj+8tpJj/Jk4B7oZt4edzyl6SNEsiNuKpZFQiNs1IesrEymOMVq+yZIE+4qgtN3msG
	 s8/e/8O0J3kVjXmnobLXn16NKE9b4KEptTF9ioGur8lNThVXLNUwrISFZi7llXXoUNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795008664;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=poQ1YG/iQmvTl3cN8cTA/VWHiQUF+/munM2IpZQMC5M=;
	b=Fo4p685xUJKsi2hOaacGZjYxgu8MROdGmdkhW7DumtzxycKk8XV3v76161kXpX3Pq2e3
	 nbfLNWMA172+JBHkuZQ3uER2UEtKgSRIxrx3ZTcaT4hUostCKyvjMGAHOH9MZxhoApaT8
	 iCa6bD/XHlWSpE+lPFe7sUrR87MHLWwN8n8Y10tQ2jbUUb9uOdqD6nc/UPCUebOO4O1kr
	 W9cz7K9hBlfkEVK7/N2qEF2rG5d4DdHTLNREJHmC875TNe8z4L3/FKE/4MU3dT+M1XjXz
	 8ZdNxDnFdgLpU5YWt2S1QVRi5IVvL07wUGd+xlYPh5nkbOcs4tPA5UPgNR1abqrbpmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	dkim=pass header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=HwNdlCFv;
	arc=none smtp.remote-ip=185.125.188.121
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E282606A325
	for <linux-trace-devel@vger.kernel.org>; Wed, 18 Nov 2026 13:31:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E282606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=HwNdlCFv
Received: from openrouter-r.lxd (2.general.fheimes.us.vpn [10.172.66.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 354203F144;
	Wed, 18 Nov 2026 13:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1795008656;
	bh=poQ1YG/iQmvTl3cN8cTA/VWHiQUF+/munM2IpZQMC5M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version;
	b=HwNdlCFvmwOn6Zr1qXzMHjorqt49lw4/wOhUO7/sTnfuMe4xiF14oK1H39+sJN1bb
	 d511U3Tt2AqE5+lUBZoEyLiofe3fAg3anFTM1F/IhTosnYjhrrl/WanN49uR/JbikN
	 BWGGIPnlVr64b/Q39/r7vHiyY8aNG7sTFXrRxOAecs/wviEOgvUGyJw6pytwLottBl
	 aDpaiqthgrRZTh30uImRUWVZ0u70ueSD9g93fR98nWYg/Wo3kUanibhB8dvoHqh0jD
	 +oyqqOqPukP8hc2JdruasjVxFJgZ49LMckTg/UuezyZUiA0ShZCEmp+0G3xuNWNEr1
	 iIBngzXIi4rcwENEVKPGnOAcKFw0X0HOb4mCzEVsXAwPGM26iGImd0bZZuFclIngU1
	 jlrVQ5vlxGHL4I30VyTcErktenNkSY00eDZS4rEN6/jqHu/xpTeMoAeUb47Zb9qCjE
	 3vW/p8+G0KtTSzyFEjVVkObK+FvYO0tTqP6pwsvl0zoioV9/Csyh4jskICjZAn3SCh
	 29LFPfERr7RWG4Mp4CkXx/8lRSI65IfZVxq4jqxMN5BpMVH9QzB3nDDw83bqGoUOFf
	 6hgipBbE30S0EtbnItv9zl7HDsYz5k0tPxLiaxPEbWkfbHu6ngKfnXMSYPZt15Nc80
	 +xqREiO2mMLV/0DqKa4fEzyw=
From: Frank Heimes <frank.heimes@canonical.com>
To: linux-trace-devel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Benjamin Drung <benjamin.drung@canonical.com>,
	Jamie Dolan <jldolan@us.ibm.com>
Subject: [PATCH 0/3] libtracefs utest: Fix trace cpu pipe and test_mem failures
Date: Wed, 18 Nov 2026 13:30:50 +0000
Message-ID: <cover.1795008446.git.frank.heimes@canonical.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Post: <mailto:linux-trace-devel@vger.kernel.org>
List-Help: <mailto:linux-trace-devel+help@vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-trace-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These fix unit test failures reported here:

  https://lore.kernel.org/linux-trace-devel/39efe87bec205b7f809b8aa49db635b6465ee530.camel@canonical.com/

 - Patch 1: on architectures with 64K pages (ppc64el), the large step of
   "trace cpu pipe" writes more than 13 GB into /tmp with the memory
   mapped buffer, which fails with ENOSPC on a tmpfs /tmp.

 - Patch 2: "make test_mem" hangs in "trace pid events filter", as the
   spinning threads starve the main thread under valgrind.

 - Patch 3: "trace cpu pipe" fails under valgrind when the memory mapped
   reader can not keep up and the kernel overwrites events.

The patches are independent of each other. I can also send them
separately, if that's preferred.

Related fixes for the same report:

 - kbuffer: Fix out-of-bounds write in kbuffer_read_buffer()
   https://lore.kernel.org/linux-trace-devel/cover.1794988946.git.frank.heimes@canonical.com/T/#u
 - libtracefs: Do not miss sub-buffers when reading a memory mapped buffer
   https://lore.kernel.org/linux-trace-devel/20261118102644.3392133-1-frank.heimes@canonical.com/T/#u
 - libtracefs utest: Fix buffer size in follow events clear test
   https://lore.kernel.org/linux-trace-devel/20261116235650.21314-1-jldolan@us.ibm.com/

Tested on ppc64el (POWER9, 64K pages, kernel 7.3) on top of master,
together with the related fixes above: "trace cpu pipe" passes in "make
test" and "make test_mem", and "make test_mem" no longer hangs.

Frank Heimes (3):
  libtracefs utest: Scale trace cpu pipe test to the sub-buffer size
  libtracefs utest: Run valgrind memory test with fair scheduling
  libtracefs utest: Account for overruns in the trace cpu pipe test

 Makefile              |  1 +
 utest/tracefs-utest.c | 42 ++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 41 insertions(+), 2 deletions(-)

-- 
2.53.0

