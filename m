Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.120
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795014887;
	b=26QYBWkuQ3IduDXPE8fbZJ1QJ21+pnCMGud1p/0xhL4yZeqY7ZDnXjMdCIFNq8lXBDtZ
	 vCwAZB/5ILEPrcMs62O3B5LrBnfDXfw/HGolZj+4cNwsFXPie5XVDwaR1WOztRv6nX9/U
	 1NFSvv8YrZi5t/CXDwNPieysY0vA3WJP9R93uWvQMte1oQ50ZrQcDkKYKLR0XmX58RPRO
	 sCNckbfGsO17JPTrN+fxV68DVb4PG7+Tc1TtJu4sK8MLriTDAKhOsIoO1bWG7D8bSiJfK
	 JTKbj8gIOk2+3xJUuNfIynjMduDHPerut+Rqn2r0SWC1jG+tYOR4rvI8/xaMmPVak0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795014887;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=h5W4SAiYGYY9J3Qux5tjapOiBUFDex9UUXEZNJzJFp4=;
	b=ZBr8sCThAcSyFg+Xcmr1VNr9M200tl9yxYoJH1iKmHSmdowAX/eyPCW5LSTmjKKN+BGp
	 EcXuGOdDKkpwdLFfHdIQpu0zQCzkg8zG8ZONqQ6toXI3AfxKoUpOT+AF32kQtC7/Ehto8
	 Nt5M895rUAQbk7+hgqgyMpBBeXpB1HI5QMV8WGgwTHw5nA5smx21LmtdeichqLxJy/FfR
	 DfBIi/2bWQ4h8wz+QA7i2HqgPxtqelA909adltEApYA/KeTZdM5XltSus/U5EDxJD7aaj
	 SiElcAIF+QPHi+uCV/R/rBLS4gizSyVEwXzDdICD3YwzUi8suA5YHRm9NRNHelqAy5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	dkim=pass header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=RqaJTEl7;
	arc=none smtp.remote-ip=185.125.188.120
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF32606A325
	for <linux-trace-devel@vger.kernel.org>; Wed, 18 Nov 2026 15:14:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7EF32606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=RqaJTEl7
Received: from openrouter-r.lxd (2.general.fheimes.us.vpn [10.172.66.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 9682040B16;
	Wed, 18 Nov 2026 15:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1795014878;
	bh=h5W4SAiYGYY9J3Qux5tjapOiBUFDex9UUXEZNJzJFp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type;
	b=RqaJTEl7xaIq+wRCo5qtopzQ92zHYZ19er+Fx5pl6z1C++604yQl29qB49FBp6Vug
	 4ngj56IgQGGO8uUypbL18HxV8PBEkcfkWF99L/Jv8Ux8tio5IETJ9YM4kotqlxC6pd
	 979SttuMVd7muapHRh00e1Pq16x4p6NmOn98uemriZOfSGM+/Y1xCW/HLhieQA4ZQQ
	 /sC98B3bZfJYkOnjkstlzq2TmLRvCrrk5z8jDJACfoC2S+bUoE22ijv0pkufV8m8WE
	 Mk/4JS115cU2Nl3x2eBXQP+gPoHlXvfM4SNQWVYUpgrr8y8p+cxZxfzaEoUAMXrg7Y
	 K6jbvzQhzu6RP/nJJNOwQVqdy1PaRQ86ixEtEhE1yy8ysJiLtga5zO1uL0rKLUoe99
	 zjnq9CpeQ5dMIGuiJRa3Fln8uH2RViEFzd47vi3z+G0dqpgtQEBRdqQMaQ2hK7+eE/
	 TQItMEWL0H5tkKL3HiassqqjDHCRYiWnjcVQcFkLwa1cNWcSxbH0cgJN+TP4dKecAS
	 5fDjGfxvqattqKz+Ez4YjcKkXOyF5SiIrmHy5pirs0XCP6xHaACypKVHPyVA4uYRLA
	 0Txs//PZxvoKBNnnQHyqC58eHjYr7knxtK9ZJBYvDhDFffieXqQf9zPUCKVP0E6W7P
	 jWr6f6E8D5NQEAOM3Y5D8Fkg=
From: Frank Heimes <frank.heimes@canonical.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org,
	Benjamin Drung <benjamin.drung@canonical.com>,
	Jamie Dolan <jldolan@us.ibm.com>
Subject: Re: [PATCH 0/2] kbuffer: Fix out-of-bounds write in kbuffer_read_buffer()
Date: Wed, 18 Nov 2026 15:14:35 +0000
Message-ID: <20261118151435.3423046-1-frank.heimes@canonical.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261118094010.545fdb4b@gandalf.local.home>
References: <cover.1794988946.git.frank.heimes@canonical.com> <20261118094010.545fdb4b@gandalf.local.home>
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Post: <mailto:linux-trace-devel@vger.kernel.org>
List-Help: <mailto:linux-trace-devel+help@vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-trace-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Wed, 18 Nov 2026 09:40:10 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> Thanks for doing all this. I'm currently way behind in my patch queue on
> the kernel side so it may be a while before I get to the trace-cmd tooling.
> I'm just letting you know so you do not think I'm ignoring your patches.

Thanks Steve for the heads-up.

Frank
