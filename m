Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C87A335C7
	for <linux-trace-devel@vger.kernel.org>; Thu, 21 Aug 2025 00:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755735363; cv=none; b=tRbHgmxKDaWSMoKApTTkwc63KSiXEfLwynep3iftm4yad+FE4BchEFGNwHSgEqXt2PE/FTjLD2qhYzF83rnWwP5o+DZcUBsb17Nz0WlH6m3s2pIWbOUm7UAF+dJUuBugnWzbDD1qta4seF4dUfeHMqohQ553xaF0hu0vBVqbhFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755735363; c=relaxed/simple;
	bh=qD+R64g13DQlVl6UabfafEACoauEAU4EDajfuuO0/lQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DCfywASTJAJXFbtl9NpRRPDaZGduWiticM+rq08Rg4p+T/3eWHOa5UZLJfU36WBwvHxu2eamrXDFdcSAsAVTGtxYaAzvOr5kjPT0WDer4GbbvnRJNbImtVsWyXIoldlPRcW2uDiN4aWKfJRclDucaYT16nUo0ml0aIrVzr7G3Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=l9OZ+2c8; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="l9OZ+2c8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=new2025; t=1755735359;
	bh=qD+R64g13DQlVl6UabfafEACoauEAU4EDajfuuO0/lQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:In-Reply-To:Message-ID:Date:From:Reply-To:Subject:To:
	 Cc:In-Reply-To:References:Resent-Date:Resent-From:Resent-To:
	 Resent-Cc:User-Agent:Content-Type:Content-Transfer-Encoding;
	b=l9OZ+2c8HMIFYGiB/r5pprVT7AuW+znHIZ8+cDANPY4MYL4HtohTpiwsY5m22FVk2
	 8JJT/PIBhJ0WNDWVE4m19dMEay0FK+YvzeQ+RJeUmPPUTa8Vi6yp3+7OxBQbMybRje
	 4CvIEzbDYnvPiPHD1VrXyexh2/bCKW+asMzuCgQOTq9ghu6BTvvBAZtwzd4GY2gYqB
	 T2DJthTqvsmleROF8CCGWlXULbvPCM6XgHEB6YewH6QmM/qRNem9rouTF9+P+1Zx/h
	 huLxDaiBgEgt6U8OykesKIJiBL1e2zEW/u0iSLXovqRe1ySVd+GR3haiMAlV7BvxFd
	 kPTNTh1UF+u2g==
Received: from biznet-home.integral.gnuweeb.org (unknown [182.253.126.177])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id 5D3ED3127F97;
	Thu, 21 Aug 2025 00:15:58 +0000 (UTC)
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Thu, 21 Aug 2025 09:15:55 +0900
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel Mailing List <linux-trace-devel@vger.kernel.org>,
	GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
	Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Subject: Re: [PATCH 0/2] ccli: Two small fixes for ccli
Message-ID: <aKZlOyjJ4gfnEVOl@biznet-home.integral.gnuweeb.org>
References: <20250820211434.1857859-1-ammarfaizi2@gnuweeb.org>
 <20250820201236.3f685799@gandalf.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250820201236.3f685799@gandalf.local.home>

On Wed, Aug 20, 2025 at 08:12:36PM -0400, Steven Rostedt wrote:
> Thanks for the updates!
> 
> FYI, I'm relicensing libccli under MIT from LGPL. Are you OK with that?

Yes, that is fine for me.

-- 
Ammar Faizi

