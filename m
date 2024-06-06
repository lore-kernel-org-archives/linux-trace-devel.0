Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF23F1974F3
	for <linux-trace-devel@vger.kernel.org>; Thu,  6 Jun 2024 15:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717688351; cv=none; b=qiRHZvT+uc69bDoX05Rh54UPlGk1WFp47xbkR0sTE6ih2Z+AoCBBv5hSJQNcVmDhltfwO43yeyCD9ahzcSZJOmidunxXbtU33/VeAmjdNR9GBn11a9hmzox9BavYxQg8YxkV/ianL0rDzmREY58swK0LJf2sU8YI7l8zl01yRVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717688351; c=relaxed/simple;
	bh=yrX6kDRd2G8fU7XqzPjMOuSWSYzU68/qoF/fsG/YUTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ow1waVjHfDPmk1aNzU+h4NCboh9FZ6mygyD82k4484NnYhvsltixFXPg3TVIZApya/ueZUpStfDokNIYBbdauh9TY4V7Nc9cJBm4/yB6BILS5Cx5e/qdkTSUz3RgCJbQql6omZoEtG5SDQ9OpDahhrpNHDPoc9g9dCYMAKKfMTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JxYOyxR2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JxYOyxR2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717688348;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LmYRpy4iSBTJwKNTfg19TEah0tV2QFO45n2YJW61IWY=;
	b=JxYOyxR23WzIRDKMm/aT5HwADExXbOgErxs6btAJbRm/XYV2hhU9DKDePvOPbGGYPHE+4o
	4woqjIADLy4qYhdPEYIMg4Rmjew+ru+mYsVTLiUHyFM7dQEmV86Z8mec2peiOjiP+COqW6
	WeeGzMi/pbpjXswVicc4nl5H/WYjz84=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-120-xQG8EOa_PAqxKn3xaLfKeA-1; Thu, 06 Jun 2024 11:39:07 -0400
X-MC-Unique: xQG8EOa_PAqxKn3xaLfKeA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3849A801F9C;
	Thu,  6 Jun 2024 15:39:07 +0000 (UTC)
Received: from fedora (unknown [10.45.224.84])
	by smtp.corp.redhat.com (Postfix) with SMTP id B5AD517ABA;
	Thu,  6 Jun 2024 15:39:05 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Thu, 06 Jun 2024 17:39:05 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 11/15] libtracefs: my_yyinput() should return 0 when no data can be read
Date: Thu,  6 Jun 2024 17:38:25 +0200
Message-ID: <20240606153830.2666120-12-jmarchan@redhat.com>
In-Reply-To: <20240606153830.2666120-1-jmarchan@redhat.com>
References: <20240606153830.2666120-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

YY_INPUT() is redefined in sqlhist.l and basically just call
my_yyinput() to do the work. However, YY_INPUT is supposed to return
YY_NULL (0 on Unix system) when no data can be read, not -1. This can
cause an overflow error in the generated sqlhist-lex.c file.

Have my_yyinput() returns zero when no buffer is found.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 src/tracefs-sqlhist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
index c7b9eff..0f678c1 100644
--- a/src/tracefs-sqlhist.c
+++ b/src/tracefs-sqlhist.c
@@ -121,7 +121,7 @@ __hidden int my_yyinput(void *extra, char *buf, int max)
 	struct sqlhist_bison *sb = extra;
 
 	if (!sb || !sb->buffer)
-		return -1;
+		return 0;
 
 	if (sb->buffer_idx + max > sb->buffer_size)
 		max = sb->buffer_size - sb->buffer_idx;
-- 
2.44.0

