# GraphDataMining_Project
Project of the course CS789-1002 (Graph Data Mining), Instructed by. Dr. Arifuzzaman, Department of Computer Science, University of Nevada, Las Vegas

------------------------------------------------------------------------
## 0_download_data.sh
This script downloads historical 1-minute crypto pair (BTC-USDT, ETH-USDT, LTC-USDT, etc.) trading data from Binance. It fetches daily data from January 1, 2018, to the current date, saving each day as a separate CSV file. The script extracts data from downloaded ZIP archives and includes a brief pause between daily requests. It also contains commented-out code for combining all daily CSVs into a single file.

## 1_data_processing.ipynb
This notebook processes obtained BTC-USDT financial data from multiple CSV files by loading and merging them. It converts Unix timestamps to datetime objects and then preprocesses the 'Close' price using a log-transform followed by Z-score normalization (standardization). It visualizes the price data before and after this normalization. Finally, it generates fixed-size, overlapping subsequences (20-point window, 5-point stride) from the normalized 'Close' price time series and saves these subsequences, their start times, and the processed data to new CSV files.

## 2_subsequences_embeddings.ipynb
This notebook trains a Variational Autoencoder (VAE) to generate 5-dimensional embeddings from 20-point BTCUSDT price subsequences. Its novelty is in the use of a combined loss function that includes a triplet loss. This triplet loss is based on Dynamic Time Warping (DTW) distances on the original subsequences, aiming to ensure the learned embeddings preserve time-series shape similarity. The notebook trains this VAE model, employing early stopping for efficiency. It then extracts the resulting latent embeddings, saves them to a CSV file, and performs basic evaluation through t-SNE visualization and Silhouette Score calculation.

## 3_community_detection.ipynb
This notebook identifies communities within previously generated time-series subsequence embeddings. It starts by loading these 5D embeddings from a CSV file. A k-Nearest Neighbors (k=50) similarity graph is then constructed, where edge weights are based on Gaussian similarity of Euclidean distances between embeddings. The Leiden algorithm is applied to this graph to detect communities. Following detection, it filters out smaller communities (fewer than 100 members). Finally, it calculates the average embedding (centroid) for each significant community and saves these centroids, along with the filtered community labels, to new CSV files.

## 4_tokenization.ipynb
This piece of code integrates various data outputs from the preceding processing stages for BTC-USDT. It loads files containing processed time series data, original subsequences, their start indices, and the candidate motif (community) labels assigned to each subsequence. The main task is to map these subsequence start indices to their actual timestamps from the main time series. It then creates a final "token sequence" by filtering this data to only include subsequences associated with significant, pre-identified communities (motifs). For validation, it plots a small random sample of original subsequences from several of these significant motifs to visually check their internal shape consistency.

------------------------------------------------------------------------
NOTE: The results in the report might differ with the saved results in the notebooks. That is because I ran all the codes again, after writing and submitting the report, to make sure everything is neat and clean, and also, train the VAE with more epochs, with slightly different hyperparameters.

NOTE.2: I did not upload the data, since it was many files, but in case it was needed, please let me know, and I will do so.
