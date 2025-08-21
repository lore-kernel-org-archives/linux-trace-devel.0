Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57BE335C7
	for <linux-trace-devel@vger.kernel.org>; Thu, 21 Aug 2025 00:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755735159; cv=none; b=Aki7Rby6PuHBGagHU3wOihJlrv7WPIpjdQvObjCq35uuOsNF/UBcdwSDeJ3NZUGjCnxZNqtFMvRQf0iJX3u1x1wbjyJpzT2ilgkjLO0fIg2WDWbU7t9pY5nCyEDfI5HUuknDZFrdCyhacUEk2sGBvMQnNjbnaGVs+eIuY15mbK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755735159; c=relaxed/simple;
	bh=ajWXCIG9upOMzsRcv6tKSEGkxzfQ31LkNA2bcsg8Y1I=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ElhCPjo+f2X+ZqkaPPaTQOtOnsosr3jm1I+whOMiWtRPJACWvlE2DfIScb7YzhVSJPBUQ4k8i0hXxrQgyJKNLhkK2ass7oASg9Wk8r6k9Nmn5epUi6/yz3UrGrveyRa5alUAMaU58o2prc0TTuty4jQ3xozyVrPI4oc5u4D9Dwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8F56B116AE3;
	Thu, 21 Aug 2025 00:12:35 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf07.hostedemail.com (Postfix) with ESMTPA id D563620038;
	Thu, 21 Aug 2025 00:12:33 +0000 (UTC)
Date: Wed, 20 Aug 2025 20:12:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc: Linux Trace Devel Mailing List <linux-trace-devel@vger.kernel.org>,
 GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>, Alviro Iskandar Setiawan
 <alviro.iskandar@gnuweeb.org>
Subject: Re: [PATCH 0/2] ccli: Two small fixes for ccli
Message-ID: <20250820201236.3f685799@gandalf.local.home>
In-Reply-To: <20250820211434.1857859-1-ammarfaizi2@gnuweeb.org>
References: <20250820211434.1857859-1-ammarfaizi2@gnuweeb.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: i4utt1c4uk9rcogafp1qp1otcdtrhr1q
X-Rspamd-Server: rspamout07
X-Rspamd-Queue-Id: D563620038
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19r4VF5czKCX5MVOjkWer+p/OiPS8wDJhA=
X-HE-Tag: 1755735153-626963
X-HE-Meta: U2FsdGVkX192bbgRHhQLPGtmvZ4GuDa/B8VVp1V/a9H7eX78f5zAiZHPgjnilu7X+48uHCCQ2RbWHNa62nNk7+GOPSKjP7E/25TWlV2FOJYvg7WjH98ROSs5R2s0Yan7f/RKVf4gpFcpzuz6PzQSqDc+Rygi2D8YMdk4WELVLgAOxxRU8/2j+ifCYKxu4QIVPGHD631KfMfiAfb16XGLrbVPMeTvScyqLzkysgrsYWh35JcdX20fYzdk6/+lZ3Zk1EFiVXqWYBmnb6INXo2Gad1WYGPd+yV5z7WMNl9cfro5DRjvMFuBdeVa2xkupc+OW/+TCKNDK8ZTeNV7e/zuyiUdodAIgreLd8ZtkhsaSn4driXChX9gt8G9hrsh2UbW

On Thu, 21 Aug 2025 04:14:32 +0700
Ammar Faizi <ammarfaizi2@gnuweeb.org> wrote:

> Hi Steve,

Hi Ammar!

> 
> Alviro and I found two small issues in the ccli code.

There's a famous Linux kernel developer named Al Viro, and when I saw the
name Alviro, I was confused and was wondering why Al was working with you.
But then I saw the Cc list ;-)

> 
> The first one is a warning about uninitialized variable in the cache
> code. The second one is an optimization issue found when clang warns
> about unused return value of strlen() calls.
> 
> Fix them.
> 
> Ammar Faizi (2):
>   ccli: cache: Fix -Wuninitialized warning
>   ccli: commands: Fix optimized `strlen()` calls

Thanks for the updates!

FYI, I'm relicensing libccli under MIT from LGPL. Are you OK with that?

Cheers,

-- Steve


> 
>  src/cache.c      | 3 +--
>  src/ccli-local.h | 1 +
>  src/commands.c   | 1 +
>  3 files changed, 3 insertions(+), 2 deletions(-)
> 
> 
> base-commit: 418ad6a341a5ab6c21be666565d62a878aa3bd18

