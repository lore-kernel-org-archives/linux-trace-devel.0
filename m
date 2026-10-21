Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=216.40.44.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792614014;
	b=t/NowFHqf8Rk3S+fluMoRTpyjCtc15g4isEcKoGzjJ4d/8NzvYonEeBgj6tYBf5Aec69
	 JPv1f6JJ6et2Zxxplc5HzGxSo8bVScnNdItGzLMTUbCFG/xg+/HU0A/quMTxzsOSeIaqF
	 Hq4TgjM9uTqzmSNsatK0s5u9t/E9IfNP2kLZfiSHQw+Or6EsYrgKQ9N9Ux8plH6+Etj6i
	 W/1DQXIskgmpTGqCp6SAA/z1Zv52fPHzvoNvHydwaNgIhlAs5EjdbuFPix2g2YhUHAdPk
	 0d3Zt041HEJbM+uSSCiljOTMwQ4ESzr9rVF3zxzxS9tFHSZ9BTrNBlLTG3yurCCzLfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792614014;
	h=DMARC-Filter:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 X-Mailer:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Stat-Signature:X-Rspamd-Server:X-Rspamd-Queue-Id:X-Spam-Status:
	 X-Session-Marker:X-Session-ID:DKIM-Signature:X-HE-Tag:X-HE-Meta;
	bh=eJFWf5oJqTYq5ffIEqMpp5EZix5/zXDXffN2uWkRiWc=;
	b=5XT+EhzW/Tg4Bet7cf3i0LkglpAasR50YhG7PvQXQkkh5tIcln1/+qRuPVOI0QqOzEEk
	 21VrtaweKteRhxeykoCJifJFp8lLkIl4ERy0GfKevRLC4sGiBpUik2pHKWmPyTQv7TNnf
	 XVAExm1eR2HgCly/1Vm+X9I97vgMA3Omk4pn80+rbBZTOYDjHdLvKPIFE1bSy6kVwXi4O
	 80kR6Mm6pPlSmeHr7Gm4mmaedGFFECx9MIww/fHxUI1ctk9i3r3MmIJVDZJ3oxab6QSjh
	 nLja7HyoMRWMz/MBaqvl3J9MUXeMmVCJ+cXa4HuXGwzGcs4imK/dSJo7AJL4BURyBPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=goodmis.org;
	spf=pass smtp.mailfrom=goodmis.org;
	dkim=pass header.d=goodmis.org header.i=@goodmis.org header.a=rsa-sha256 header.s=dkim1 header.b=k3PLzp2k;
	arc=none smtp.remote-ip=216.40.44.11
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E56606A31A
	for <linux-trace-devel@vger.kernel.org>; Wed, 21 Oct 2026 20:20:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 68E56606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=goodmis.org header.i=@goodmis.org header.a=rsa-sha256 header.s=dkim1 header.b=k3PLzp2k
Received: from omf07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 44CB3120698;
	Wed, 21 Oct 2026 20:20:12 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf07.hostedemail.com (Postfix) with ESMTPA id E16E220030;
	Wed, 21 Oct 2026 20:20:10 +0000 (UTC)
Date: Wed, 21 Oct 2026 16:20:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] trace-cmd record: Check allocation of creating path
 variable
Message-ID: <20261021162008.3696574a@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Post: <mailto:linux-trace-devel@vger.kernel.org>
List-Help: <mailto:linux-trace-devel+help@vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-trace-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zcoc6irhrprsn1x35q5hgezmqsbxfj3m
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: E16E220030
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18NX+NSMh+3k1BGuCmcmtwlCj4pWzpGFJY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=eJFWf5oJqTYq5ffIEqMpp5EZix5/zXDXffN2uWkRiWc=; b=k3PLzp2k7Pt+Ra/aAgPb9yhKZU3N6KHYtGLJ36t7bGneEug/wK8KTbFDpcdb0RYoH+nndhe2Y646EG2m+pl7SCvv8liRrx2/lWTzq4bR4cSTHEb9s21Dx7ygMdpG5uA+JH7dXgyh/DoT42wD/cteAk85xXnRa5L9IBMIYw0ZNVw=
X-HE-Tag: 1792614010-697468
X-HE-Meta: U2FsdGVkX19eZZrgjhwnD+2KufYVfQQiDxCxoOTrXYa7CBgHbThdLfSPZPAZ+GwSxBIN8xAQ9gDrUJTFhJlsJNb/nWxahJjtlbaSSEXeeCbMJfZRNE/j6nb7IimXi6vU04Z18dFs59XD/Z08Mjt3XFAXbQ8gYQmznNw9306ttaGJV3UoM8coUTwk6WR2ALPqjyyLgqDlw4BbOeRI4YggTDp226ZtTqd9uyMQYVhcxFxGffzfAFByx3cs4t57ffXHjaIuWC4VoBEZfF9oXXZtotqSGqqiQKFYacqt7MNUNzvOhfItkGrWUkKW9yOf9s8TGBMTSlGNEC0LpduUutYkDtLDbnFqNKo3aXQtNwpMp1rOG28psseWpbRme53pqdvZ+6bnhku4Hp8Iqf1ML485eQ==

From: Steven Rostedt <rostedt@goodmis.org>

The reset->path = strdup(file) should check if the allocation fails.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217126
Reported-by: Markus Elfring <Markus.Elfring@web.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 1ee3effca114..3a6e4759aed2 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -262,6 +262,8 @@ static void add_reset_trigger(const char *file)
 	if (!reset)
 		die("Failed to allocate reset");
 	reset->path = strdup(file);
+	if (!reset->path)
+		die("Failed to allocate path");
 
 	reset->next = reset_triggers;
 	reset_triggers = reset;
-- 
2.53.0

