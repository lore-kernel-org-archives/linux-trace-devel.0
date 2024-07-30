Received: from mail.nearlyone.de (mail.nearlyone.de [49.12.199.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE85D78276
	for <linux-trace-devel@vger.kernel.org>; Tue, 30 Jul 2024 16:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.199.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357943; cv=none; b=Q9VFN6YjkCRjIDF5wQZxC/YfQLCUo2op6dm+mKXxH0VwNFMaXQ6vbqUUl2sf7qP5eKzY1Hj9V6RLwpIo4EXNIEMm9fXB+RtRWVQ9nXx8pz55CxQ6NsikUyTTCJ5TifALzX0e9EUh/6yUDICpxBmS5M4psVSnrxvsvnMqJqHbLPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357943; c=relaxed/simple;
	bh=8LKl6xocY/S4nEeYWcsGTF8H3fdWrgQl/P/InMNKtTs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qs9vt+bWXrOvQASkWsdi2BgqdFzV3wjtEDiDqKEcwjE7yLxKNKZaMxJgXbwWDkKAhkKW15sgxNSZzVZGc8eH1g4uvs9lTfRoqr99YUCibynmM1MvzTLQ4dfUOlAVRwW1hYubSz99a+C2Y37yq4nxe2M+i2lqV9isRFCOREv3c2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=monom.org; spf=pass smtp.mailfrom=monom.org; dkim=pass (2048-bit key) header.d=monom.org header.i=@monom.org header.b=ByaUjfRZ; arc=none smtp.client-ip=49.12.199.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=monom.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=monom.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=monom.org header.i=@monom.org header.b="ByaUjfRZ"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 71EF1DAC08;
	Tue, 30 Jul 2024 18:36:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=monom.org; s=dkim;
	t=1722357374; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=0u4FP4Mm91l99NHZsoZwaRX+n/Z0M0iX/Nte95eOYSU=;
	b=ByaUjfRZZ9Ahq5BaIuml1KTBMjRhKiKh453i8b0GeeqSym2M1z1H1Yk+tXtmn0watwA0AX
	c/uZ2UJ5uaEKHgwIeihu3FdUYfkp/RMs9UFAWfoqqu/ngAIelXr6ihmOng+KqGSgGKJ9iL
	nQc37maBKN1E4S2/tBHV3kD/OtWmQoNWBbmbaqq8k2S3Ab63Z5m3gP0D9YifYs5vQQI6Ti
	PbDarVujHG65x9/5UGN7qdYybhcMgtiRDM1HhXekaTUMrPrEJklnl5Zttul/LgjvEcMdPd
	2Ussx2siwCCaiWGD1LbjczQ5m16sYm7yzxM7CPtrA/mtEGi/Tl1rB1mpe+vTsQ==
Date: Tue, 30 Jul 2024 18:36:08 +0200
From: Daniel Wagner <wagi@monom.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>, 
	Tejun Heo <tj@kernel.org>, "Schmidt, Adriaan" <adriaan.schmidt@siemens.com>
Subject: Re: [PATCH] trace-cmd meson: Fix include file for swig python build
Message-ID: <6y2lie344hch7mbcna4zrtxntzdr4bi3zkef2mbbpf5xjozsy7@ywt7iqo57hez>
References: <20240724143819.073877b3@gandalf.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240724143819.073877b3@gandalf.local.home>
X-Last-TLS-Session-Version: TLSv1.3

On Wed, Jul 24, 2024 at 02:38:19PM GMT, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> The header trace-cmd-private-python.h was recently moved to
> lib/trace-cmd/include/private. Change the meson.build file to reflect this
> change.
> 
> Link: https://lore.kernel.org/all/Y+w51nOhNd+PGo%2Fk@slm.duckdns.org/
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

looks good to me.

Reviewed-by: Daniel Wagner <dwagner@suse.de>
