Received: from smtpcmd0756.aruba.it (smtpcmd0756.aruba.it [62.149.156.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C679533FE06
	for <linux-trace-devel@vger.kernel.org>; Sun,  8 Feb 2026 20:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.156.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770584203; cv=none; b=o5ALhSDpEYz14zVSvWuGlwdCki8dQhOKITc2fAXv94nMLreOe0AI82UQ2W3vJu/kQKaghVmGPIYSJLDoDlj58GIUyS/GCAqj6QvQqsq3+sfmmqz+YSqmiG6wPSthYJkjpJaDjpCAH+Dl/fOCKLw71zYIz2Lf29MwEfvnOHuQsTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770584203; c=relaxed/simple;
	bh=CPYIil8x0Sa9meGsWAEH+a2MuYl9oNNGvn/LX+t8Qkw=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=LYIOHqYWwKJqhPC0/XQOgvITZgrKGrmOEsoCLa+XgKtRLjLv6NgkGArybL4xaihBzzbtdfqhQie0gXA6pEOC5NY9xqDyHmd1tybEDHDxXTp33A2A03Yjt6NNvkwOsoeR9znhlaJvnCtFApI8FwNiwjyTsUT01/0ooW2vvfLO+GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=benettiengineering.com; spf=pass smtp.mailfrom=benettiengineering.com; dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.b=X7S5zGLG; arc=none smtp.client-ip=62.149.156.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=benettiengineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benettiengineering.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.b="X7S5zGLG"
Received: from [192.168.50.134] ([84.33.84.190])
	by Aruba SMTP with ESMTPSA
	id pBmevOSuItpTfpBmev1o3o; Sun, 08 Feb 2026 21:53:32 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1770584012; bh=CPYIil8x0Sa9meGsWAEH+a2MuYl9oNNGvn/LX+t8Qkw=;
	h=Date:MIME-Version:To:From:Subject:Content-Type;
	b=X7S5zGLGFd391ygUYjj4FL19LzZ7cHI1O9ePoTe3I0/JPUz0/OuuPPMe0rv4YcNCZ
	 abkNWJa9ULzdxRKTvVECZesN6U722H4opkqyc548k9oCLQSCXcaZhwc84JHTHMdCwT
	 YPpwmLsTz/9L0TLOtm9fosYLtVTF2PquWCHF5maO8GlYSChW6FfahpH9BKOIqopW8x
	 r7psNUAMYjPVvTZovXKvB5PB/clvdbPVzZ/72qpXDMHDOc/TbIxm1ogvCUSHCoAAhv
	 I4l3AM2/S+2lqs/D0mbk9yNiGlnryffaB2m+r4SyG/aeyGM10tvAWKKLDlYZn5H7J+
	 MO/Us78foTBIw==
Message-ID: <5984db8a-a93a-4efc-9b81-c87140d38042@benettiengineering.com>
Date: Sun, 8 Feb 2026 21:53:31 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-trace-devel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
From: Giulio Benetti <giulio.benetti@benettiengineering.com>
Subject: Build failure bft for trace-cmd and libtraceevent
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfNE1rwbF5zAyKodEfyJwavSDR1iq7luZ9tCPiryvWRHqGtcs2Yb07OK8mLMjj1gyAutz4OU5+9WMA/L/ef0syr/RuVceSITRdvwMyUxpZWB3j8fqgwHp
 1gtS60rRnbxZH6FuP1mzy+A4plMQCG/hH0JVaVlVp+3S0tWchlYUlyVcSoYNB3FsRv+roYrCuhWjySYT+NScpUNfOfB/z1YBc/+FmIxsb7qx5Nqp1yP2+/1s
 if9mCIIqwxPKxEtU9d1smQkPiwvGi2bEwLfGumKLc1Q=

Hi Steven, All,

in Buildroot I'm bumping libtraceevent to 1.9.0 and trace-cmd to 3.4 and
experiencing build failures because of the change of uapi/linux/bft.h
defines/enums

I see as possible solution to create a bft_compat.h to deal with
different Linux versions, but this is not a quick solution.

Otherwise the solution could be to switch according to Linux version
between print_args() with and without bft support, basically re-adding
the function here:
https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/commit/?id=e798103c0815e6642e74d9317c325b2c62681f2e

What do you think about it?

Best regards
Giulio Benetti
