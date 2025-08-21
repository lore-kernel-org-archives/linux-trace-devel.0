Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F731335C7
	for <linux-trace-devel@vger.kernel.org>; Thu, 21 Aug 2025 00:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755735533; cv=none; b=JIaYl2lFRQ1NwvKewohRvM7144lDSgMvyzZtCZdJ91hB043TNJk1sOSh+5JYSExThksF/vl5956Ti+dMDPeYJteLojaq0ze+bE/Q31/SU4NwYuA9OInjZNdRv85D6XGJlGtGSkAQpuS4zU/vgE0CGJKhkya6IsZvtL/yQhO8jro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755735533; c=relaxed/simple;
	bh=007tRnsDGUre0UEG4pbgEcE3AexyKh/eJkm1hdMU9cE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zx0ruN4R85w2HIm1ZUwt7jbtGVbbFiIgi3UbQIobYGQ+1Drr8dMr6K5juZ9dvl6w8aO89Dwzie8b0its9fpHoc3tJMFP2IcTIEXznzHOIK3esXd0JKaV1fH51bEx17Gfecg+3WA97cO8CJ/ktgCIlRitd5qEHM0XNAAmnDFiBhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1EDBD1A01C8;
	Thu, 21 Aug 2025 00:18:50 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf02.hostedemail.com (Postfix) with ESMTPA id 69E3880011;
	Thu, 21 Aug 2025 00:18:48 +0000 (UTC)
Date: Wed, 20 Aug 2025 20:18:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc: Linux Trace Devel Mailing List <linux-trace-devel@vger.kernel.org>,
 GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>, Alviro Iskandar Setiawan
 <alviro.iskandar@gnuweeb.org>
Subject: Re: [PATCH 0/2] ccli: Two small fixes for ccli
Message-ID: <20250820201851.763972f7@gandalf.local.home>
In-Reply-To: <aKZlOyjJ4gfnEVOl@biznet-home.integral.gnuweeb.org>
References: <20250820211434.1857859-1-ammarfaizi2@gnuweeb.org>
	<20250820201236.3f685799@gandalf.local.home>
	<aKZlOyjJ4gfnEVOl@biznet-home.integral.gnuweeb.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: e37x8pemfehhnzeouyff3nsqpodeykwd
X-Rspamd-Server: rspamout07
X-Rspamd-Queue-Id: 69E3880011
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+o6JbIxDuoqiesBzNKzSF3pbJBVjZb/20=
X-HE-Tag: 1755735528-929633
X-HE-Meta: U2FsdGVkX18hyEwN6INkD5ccxegZ8OJ9DKNwAj4ZVNI5da0Ch6sHV1B3iqQNaIgHkL8QVFRbxtMmrt0lIHKlkWnY/BZo3PlIzvGC6G2noAqx3fmf140TiGCnccUHwwaIe/XEsZILv7TOaxaJlqAZFzW+nhHa0ie7b5uQX6Hvkpg1fgvZ1kD/fY0BG3lc8ntSS3+7L486rmrlmK5/XM8vqjehvAVrHcnwYBKyYHtYD3kfjXV1lMMgmZC6gDQA4twfTnlPbWhn9z/+ofSgiaLm/wMeELXNUf2j31zyVImuUcO9KmFZsdPf7yALQLP3q6q7NZGksSZKCDZSgCPd+9XgXFxztd03DJB9z63oOgpkhxOoxTOCmEiqaCTmtu0QYFpoiVuOJ6x1zNhb5zvTbJJc2w==

On Thu, 21 Aug 2025 09:15:55 +0900
Ammar Faizi <ammarfaizi2@gnuweeb.org> wrote:

> On Wed, Aug 20, 2025 at 08:12:36PM -0400, Steven Rostedt wrote:
> > Thanks for the updates!
> > 
> > FYI, I'm relicensing libccli under MIT from LGPL. Are you OK with that?  
> 
> Yes, that is fine for me.
> 

Ah, sorry, you already acked it. ;-)

-- Steve
