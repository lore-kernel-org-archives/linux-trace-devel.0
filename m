Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADFB381AA8
	for <linux-trace-devel@vger.kernel.org>; Sun,  8 Feb 2026 22:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770588093; cv=none; b=Q3kXfGz1njYRqBARLECYUoGxg7pmTU/WTg3gqgVfUANm2ExxDR3I271+sSTpd9HhoFRICGJ4my9CKtRQE1G0jO+srmm6uCtTh8zbSg2gQbsHOZx0yXu4l2nopb11B2sl+sFdfCfJ6psw/vrPqOcTc4kNaAub/5YTdB1ATTAyLjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770588093; c=relaxed/simple;
	bh=jE4IYuT+sWgqbPcWyx90riF+fZAFqvHp3XK/oUHgZd8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TUNU9jfJHi178P0NEYQSUbwCs/vK2Vcvr1aJ0L+jlRitjv1NwnB3cKpzUVtPLIOgcKGPiIjbnSbiBOcmrYVu/hAnlN2eaOmJ30FQoj/2IXjZea3YLbe9Y8xqSejW+tFTPAIG11baO0PyqE2wc+yQ7zjmtWDFaXhXAI9yR40LoZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 37402140677;
	Sun,  8 Feb 2026 22:01:26 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf03.hostedemail.com (Postfix) with ESMTPA id A584F6000D;
	Sun,  8 Feb 2026 22:01:24 +0000 (UTC)
Date: Sun, 8 Feb 2026 17:01:23 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Giulio Benetti <giulio.benetti@benettiengineering.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: Build failure bft for trace-cmd and libtraceevent
Message-ID: <20260208170123.37d468a0@robin>
In-Reply-To: <1624899e-97c3-483e-b859-2f6184458e5f@benettiengineering.com>
References: <5984db8a-a93a-4efc-9b81-c87140d38042@benettiengineering.com>
	<20260208163211.63e645cb@robin>
	<1624899e-97c3-483e-b859-2f6184458e5f@benettiengineering.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 56gfk373z4nkdtznq6d8qezrkywkt8nq
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: A584F6000D
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+h8Jxg8HiilW8Mwplk7sAQcNEiD+KWnTg=
X-HE-Tag: 1770588084-663036
X-HE-Meta: U2FsdGVkX18WU3GdJ3p2+6s8WYW4DzNkOCMMuJDkMEXt+KaHu02zV1dGG5+5gbtK7LBmeSB6CokAUmcUjQQokSWVoJn4fpWFH31Ow0AoIz/IpBfAaswP8vyx8bXhea719dstZq90hT5QinDHicxToggAk+nhRZv5Wp5YGHgQYsKE58pGVxRPe6MliuMfFhFijSnT6w37WFgLlxgTPPaGU6sadrbPgzgU32MAp5rzAkNyJ+JTipeqjOag+4zgrByyiDoupClQ7iAiuW1qmvipuWxX1IKYF5hLyrzZgvrajnk+UrbtLrOXU1E/vh5W4Y23XPk06vH6Whi+2x57jfsgW/z9davpQI3QmNTXNk/lbPkItlWge/EYAEzIDaSWXafSP7OpNbNHetFBtIqiG753czpf+W2wVsNJniYwGp8Fo/ux0CVDiwP2fXlnKIAEzN+msABLgrBK4FvYZ+SDriUxDA==

On Sun, 8 Feb 2026 22:44:24 +0100
Giulio Benetti <giulio.benetti@benettiengineering.com> wrote:

> Oh, I've forgotten to post the build failure, here it is and it's due to
> dealing with different Linux versions:

OK, if it is a build failure, we should add logic to make sure it
builds properly and if not, warn and build without BTF. Kind of like
what trace-cmd did when I was first started developing this:

  https://lore.kernel.org/20260203233451.2118849-5-rostedt@goodmis.org

-- Steve
