Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C3DAD4B
	for <linux-trace-devel@vger.kernel.org>; Thu, 21 Aug 2025 00:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755735826; cv=none; b=gbZd+qDWHTFq4QFZ/jMuz9DLeYiqqb5/kzQhnO5jM+C5AS/Q8Y4zAl1lxKANYymuqnjOIbvbEtrlVr+Jwd/ps9OhB68eZ+rcu893zCuP3C7E7XQ8mlV1r1P1/q1vWXCJHOO+hT1fsupan2+e3PpODX3VxGtEMJxGvJBufxWo+Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755735826; c=relaxed/simple;
	bh=zzXBIHRoJZndfG1BjhSxtWaa14qaiHJ/EfjQLDP4mVE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JA0qbaiwdl0gikKpXz8CvATl+/4IqUMZa+S15ZNO9fMqAjHj/6mNSpFuBOfGRtWws2X8iL/BvhC4Ys93ZE+eVz78ERCovu3VKrBgQOU5zIYp2C8CAqL96NsLFzG8chZCDMZrgmPXmx1vjcF/3zo3VWlqfjOcTDk3cZ7z1eETtr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 42AA714017A;
	Thu, 21 Aug 2025 00:23:43 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf09.hostedemail.com (Postfix) with ESMTPA id 9579D2002B;
	Thu, 21 Aug 2025 00:23:41 +0000 (UTC)
Date: Wed, 20 Aug 2025 20:23:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc: Linux Trace Devel Mailing List <linux-trace-devel@vger.kernel.org>,
 GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>, Alviro Iskandar Setiawan
 <alviro.iskandar@gnuweeb.org>
Subject: Re: [PATCH 0/2] ccli: Two small fixes for ccli
Message-ID: <20250820202344.62c64c30@gandalf.local.home>
In-Reply-To: <20250820201851.763972f7@gandalf.local.home>
References: <20250820211434.1857859-1-ammarfaizi2@gnuweeb.org>
	<20250820201236.3f685799@gandalf.local.home>
	<aKZlOyjJ4gfnEVOl@biznet-home.integral.gnuweeb.org>
	<20250820201851.763972f7@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: c49embseudzhywnf9xcp3bc4wb8xcsuz
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: 9579D2002B
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+yj8qvRt3FdzDrbbktFuDVLEXicJnlMuo=
X-HE-Tag: 1755735821-551317
X-HE-Meta: U2FsdGVkX1+l4+/N9Rymj0Uu7gJuSELma87PyB8RcfyuQE7J8NLmxUIJe/tkE8SVNv7c1K4Qgg4tBZREem/DPiaPjRKiEEY8uJIXG3tjAhCuWKNGp/x6Stj8fmCP+oVys3uLHQ6KleTi/R/DzVPhFGSlgTApF6kc+/4XDI5BoJN8qvM5MpVi9593kDSe6ARTkb9S0JFFg5CDX+zfUjDP7juBsxkJ3AxyU8yrXdP+cFS1mJK58GcWfpxTajs8dKqx82LSuEt9qZM8xgiDeFeIvNobbZdo+B1zKnWFkSrakdHQloyabyeioFmq9sw6G9zBQO3Bh9+qXNrVBQdpXk2OTECkoZDd7/ccgmWwu3viCUkKFJ5/7G3h+zxrKRA9m6LoMI+yyMd8EFt4eEja2A7cba+eQLOkJ32w7n3lSJO1/f3vLpgqTQlFJ+WIvAk3quNH

On Wed, 20 Aug 2025 20:18:51 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 21 Aug 2025 09:15:55 +0900
> Ammar Faizi <ammarfaizi2@gnuweeb.org> wrote:
> 
> > On Wed, Aug 20, 2025 at 08:12:36PM -0400, Steven Rostedt wrote:  
> > > Thanks for the updates!
> > > 
> > > FYI, I'm relicensing libccli under MIT from LGPL. Are you OK with that?    
> > 
> > Yes, that is fine for me.
> >   
> 
> Ah, sorry, you already acked it. ;-)

And I just merged all the changes to the main branch.

It's still not ready for 1.2 release (hence the "dev"), but it's getting there.

Unfortunately, I need to focus on Linux kernel changes for a while, so this
is going back on the back burner :-p

-- Steve
